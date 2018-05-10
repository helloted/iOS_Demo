//
//  H264ToFlv.m
//  VTToolbox
//
//  Created by iMac on 2018/5/7.
//  Copyright © 2018年 Ganvir, Manish. All rights reserved.
//

#import "H264ToFlv.h"
#import "RTMPPusher.h"

typedef enum : NSUInteger {
    FLVTagHeaderTypeAudio  = 8,
    FLVTagHeaderTypeVideo  = 9,
    FLVTagHeaderTypeScript = 12,
} FLVTagHeaderType;


NSData *convertIntergerToHex32Data(NSInteger ori){
    NSMutableData *sizeData = [[NSMutableData alloc] init];
    Byte tempByte;
    tempByte = (Byte)((ori&0x00FF0000)>>24);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    tempByte = (Byte)((ori&0x00FF0000)>>16);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    tempByte = (Byte)((ori&0x0000FF00)>>8);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//17
    
    tempByte = (Byte)(ori&0x000000FF);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//18
    return sizeData;
}

NSData *convertIntergerToHex24Data(NSInteger ori){
    NSMutableData *tempData = [[NSMutableData alloc] init];
    Byte tempByte;
    tempByte = (Byte)((ori&0x00FF0000)>>16);
    [tempData appendBytes:&tempByte length:sizeof(tempByte)];
    tempByte = (Byte)((ori&0x0000FF00)>>8);
    [tempData appendBytes:&tempByte length:sizeof(tempByte)];
    tempByte = (Byte)(ori&0x000000FF);
    [tempData appendBytes:&tempByte length:sizeof(tempByte)];
    return tempData;
}

void writeInterToDataWithHex24(NSInteger oriInt,NSMutableData *desData){
    NSMutableData *tempData = [[NSMutableData alloc] init];
    Byte tempByte;
    tempByte = (Byte)((oriInt&0x00FF0000)>>16);
    [tempData appendBytes:&tempByte length:sizeof(tempByte)];
    tempByte = (Byte)((oriInt&0x0000FF00)>>8);
    [tempData appendBytes:&tempByte length:sizeof(tempByte)];
    tempByte = (Byte)(oriInt&0x000000FF);
    [tempData appendBytes:&tempByte length:sizeof(tempByte)];
    [desData appendData:tempData];
}

void writeInterToDataWithHex32(NSInteger oriInt,NSMutableData *desData){
    Byte tempByte;
    tempByte = (Byte)((oriInt&0x00FF0000)>>24);
    [desData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    tempByte = (Byte)((oriInt&0x00FF0000)>>16);
    [desData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    tempByte = (Byte)((oriInt&0x0000FF00)>>8);
    [desData appendBytes:&tempByte length:sizeof(tempByte)];//17
    
    tempByte = (Byte)(oriInt&0x000000FF);
    [desData appendBytes:&tempByte length:sizeof(tempByte)];//18
}

@interface H264ToFlv()

@property (nonatomic, strong)RTMPPusher         *pusher;
@property (nonatomic, strong)NSMutableArray       *h264NALUArray;

@end

@implementation H264ToFlv

int first1=0;
int topTagLen=16;
int metaFixLen=27;
int first2=0;
int videoLen=0;
int videoTagFixLen=20;

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)start{
    NSString *h264path = [[NSBundle mainBundle]pathForResource:@"b" ofType:@"h264"];
    [self splitH264FileFrom:h264path];
    [self packageFlv];
}


-(void)splitH264FileFrom:(NSString *)path{
    NSData *h264file = [NSData dataWithContentsOfFile:path];//H264裸数据
    int count_i= -1;
    Byte *contentByte = (Byte *)[h264file bytes];
    Byte byte;
    //h264是一个个NALU单元组成的，每个单元以00 00 01 或者 00 00 00 01分隔开来，每2个00 00 00 01之间就是一个NALU单元
    for(int i=0;i<[h264file length];i++){
        if(contentByte[i+0]==0x00&&contentByte[i+1]==0x00&&contentByte[i+2]==0x00&&contentByte[i+3]==0x01){ //分割符
            [self.h264NALUArray addObject:[[NSMutableData alloc] init]];
            i=i+3;
            count_i++;
        }else if(contentByte[i+0]==0x00&&contentByte[i+1]==0x00&&contentByte[i+2]==0x00){//分割符
            [self.h264NALUArray addObject:[[NSMutableData alloc] init]];
            i=i+2;
            count_i++;
        }else{
            if(count_i>-1){
                byte =contentByte[i];
                [[self.h264NALUArray objectAtIndex:count_i] appendBytes:&byte length:sizeof(byte)];
            }
        }
    }
}

// TagHeader的总长度为11
- (NSData *)creatflvTagHeaderWithType:(NSUInteger)type tagDataSize:(NSUInteger)size timeStamp:(NSUInteger)timeStamp{
    NSMutableData *headerData = [[NSMutableData alloc] init];
    Byte tempByte;
    
    //第1个byte为记录着tag的类型，音频（0x8），视频（0x9），脚本（0x12）
    tempByte = (Byte)type;
    [headerData appendBytes:&tempByte length:sizeof(tempByte)];
    
    // 第2-4bytes是数据区的长度
    writeInterToDataWithHex24(size, headerData);
    
    // 第5-7个bytes是时间戳
    writeInterToDataWithHex24(timeStamp, headerData);
    
    //第8字节拓展时间戳,前面不够用的时候用,基本上为0就可以
    tempByte = 0x00;
    [headerData appendBytes:&tempByte length:sizeof(tempByte)];
    
    //第9-11个bytes是streamID，但是总为0；
    Byte *streamID = (Byte *)0x000000;
    [headerData appendBytes:&streamID length:sizeof(uint8_t) * 3];
    
    
    return headerData;
}


- (NSData *)createMetaData{
    NSMutableData *metaData = [[NSMutableData alloc] init];
    
    // 第一段为固定
    Byte *temp = (Byte *)0x02000A;
    [metaData appendBytes:&temp length:3];
    [metaData appendData:[@"onMetaData" dataUsingEncoding:NSUTF8StringEncoding]];
    
    return metaData;
}

- (NSData *)getFLVMetaElementWith:(NSString *)name value:(NSUInteger)value{
    NSMutableData *metaData = [[NSMutableData alloc] init];
    return metaData;
}

- (NSData *)createPreviousTagSizeWithLength:(NSUInteger)length{
    NSMutableData *sizeData = [[NSMutableData alloc] init];
    Byte tempByte;
    tempByte = (Byte)((length&0x00FF0000)>>24);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    
    tempByte = (Byte)((length&0x00FF0000)>>16);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    tempByte = (Byte)((length&0x0000FF00)>>8);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//17
    
    tempByte = (Byte)(length&0x000000FF);
    [sizeData appendBytes:&tempByte length:sizeof(tempByte)];//18
    return sizeData;
}

/***
 整个的flv文件其实是：FLV header + previous tag size0 + tag1 + previous tag size1 + tag2 + previous tag size2 + ... +tagN + previous tag sizeN。
 tag1是metadata，记录视频的一些信息；tag2是视频配置信息（AVC decoder configuration record），tag3是音频配置信息（如果没有音频则去掉此项），tag4以及之后的tag就是音视频数据了。
**/

-(void)packageFlv{
    
    NSData *data = [self createMetaData];
    NSLog(@"---------%@",data);
    
    NSMutableData *flvData = [[NSMutableData alloc] init];
    Byte tempByte;
    // 1~9为FLV Header
    
    // 前三位 0x46 0x4c 0x56为文件标识"FLV"
    [flvData appendData:[@"FLV" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // 第四位是版本号
    tempByte = 0x01;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//4
    
    // 流的信息
    tempByte = 0x01;//0x01--代表只有视频，0x04-－只有音频，0x05-－音频和视频混合
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//5
    
    // 接下来的四位为Header的长度
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//6
    
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//7
    
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//8

    tempByte = 0x09;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//9
    
    // 接下来是FLV Body，[Previous Tag Length+Tag]、[Previous Tag Length+Tag]、[Previous Tag Length+Tag]....
    
    // Previous Tag Length
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//10
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//11
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//12
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//13
    
    //Tag = Tag Header + Tag Data
    //TAG Head 11
    NSUInteger tagDataLength = topTagLen+ [[self.h264NALUArray objectAtIndex:0] length] + [[self.h264NALUArray objectAtIndex:1] length];
    NSData *headerTagData = [self creatflvTagHeaderWithType:FLVTagHeaderTypeVideo tagDataSize:tagDataLength timeStamp:0];
    [flvData appendData:headerTagData];
    
    //
    tempByte = 0x17;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    //------------
    
    tempByte = 0x01;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0x42;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0x80;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0x0D;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0xFF;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    tempByte = 0xE1;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    

    tempByte = (Byte)(([[self.h264NALUArray objectAtIndex:0] length]&0x0000FF00)>>8);
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
    
    tempByte = (Byte)( [[self.h264NALUArray objectAtIndex:0] length]&0x000000FF);
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    [flvData appendData:[self.h264NALUArray objectAtIndex:0]];
    
    tempByte = 0x01;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    

    tempByte = (Byte)(([[self.h264NALUArray objectAtIndex:1] length]&0x0000FF00)>>8);
    
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
    
    tempByte = (Byte)([[self.h264NALUArray objectAtIndex:1] length]&0x000000FF);
    
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    [flvData appendData:[self.h264NALUArray objectAtIndex:1]];
    

    NSInteger naluLength;
    int time_h=0;//初始时间戳
    for(int j=2;j<[self.h264NALUArray count];j++){
        if(j==2){
            naluLength =metaFixLen+[[self.h264NALUArray objectAtIndex:0] length]+[[self.h264NALUArray objectAtIndex:1] length];
        }else{
            naluLength = videoTagFixLen+[[self.h264NALUArray objectAtIndex:j-1] length];
        }
        
        NSData *lengData = convertIntergerToHex32Data(naluLength);
        [flvData appendData:lengData];
        
        tempByte = 0x09;
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        naluLength = [[self.h264NALUArray objectAtIndex:j] length]+9;
        writeInterToDataWithHex24(naluLength, flvData);
        
        //定义3个时间戳
        
        lengData = convertIntergerToHex24Data(time_h);
        [flvData appendData:lengData];
        
        //备份时间戳
        tempByte = 0x00;
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        //定义3个3bytes是streamID
        tempByte = 0x000000;
        [flvData appendBytes:&tempByte length:3];//18
        
        //---------
        
        Byte *contentByte = (Byte *)[[self.h264NALUArray objectAtIndex:j] bytes];
        
        if((contentByte[0]& 0x1f) == 5){
            tempByte = 0x17;
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
            
        }else{
            tempByte = 0x27;
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        }
        tempByte = 0x01;
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//
        
        //-------
        
        tempByte = 0x00;
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        tempByte = 0x00;
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        tempByte = 0x00;
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        //--------
        
        naluLength= [[self.h264NALUArray objectAtIndex:j] length];
        
        NSLog(@"len:%ld",(long)naluLength);
        
        writeInterToDataWithHex32(naluLength, flvData);
        [flvData appendData:[self.h264NALUArray objectAtIndex:j]];
        
        time_h=time_h+40;//采样率是11500时候，是40递增，加倍就是80递增
        
    }//for
    
    naluLength = videoTagFixLen+ [[self.h264NALUArray objectAtIndex:([self.h264NALUArray count]-1)] length];
    writeInterToDataWithHex32(naluLength, flvData);
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *flvPath = [documentPath stringByAppendingPathComponent:@"b.flv"];
    [flvData writeToFile:flvPath atomically:YES];
}

- (NSMutableArray *)h264NALUArray{
    if (!_h264NALUArray) {
        _h264NALUArray = [NSMutableArray array];
    }
    return _h264NALUArray;
}

@end
