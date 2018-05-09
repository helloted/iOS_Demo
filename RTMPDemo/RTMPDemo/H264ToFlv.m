//
//  H264ToFlv.m
//  VTToolbox
//
//  Created by iMac on 2018/5/7.
//  Copyright © 2018年 Ganvir, Manish. All rights reserved.
//

#import "H264ToFlv.h"
#import "RTMPPusher.h"

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

-(void)packageFlv{
    NSMutableData *flvData = [[NSMutableData alloc] init];
    
    // 1~9为FLV Header
    
    // 前三位 0x46 0x4c 0x56为文件标识"FLV"
    Byte tempByte;
    tempByte = 0x46;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//1
    tempByte = 0x4C;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//2
    tempByte = 0x56;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//3

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
    
    /**
     第1个byte为记录着tag的类型，音频（0x8），视频（0x9），脚本（0x12）
     */
    tempByte = 0x09;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//14
    
    //2~4为tag数据区的长度
    NSUInteger tagDataLength = topTagLen+ [[self.h264NALUArray objectAtIndex:0] length] + [[self.h264NALUArray objectAtIndex:1] length];
    tempByte = (Byte)((tagDataLength&0x00FF0000)>>16);
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
    tempByte = (Byte)((tagDataLength&0x0000FF00)>>8);
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
    tempByte = (Byte)(tagDataLength&0x000000FF);
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    //下面三个组成时间戳
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    //拓展时间戳,前面不够用的时候用
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    
    //3bytes是streamID,总为0
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    tempByte = 0x00;
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
    //Meta Tag data
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
    
    
    
    
    //----------------
    
    int fuck;
    
    int time_h=0;//初始时间戳
    
    for(int j=2;j<[self.h264NALUArray count];j++){
        
        if(j==2){
            
            fuck=metaFixLen+[[self.h264NALUArray objectAtIndex:0] length]+[[self.h264NALUArray objectAtIndex:1] length];
            
            //  NSLog(@"len:%d",fuck);
            
            tempByte = (Byte)((fuck&0x00FF0000)>>24);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
            
            
            tempByte = (Byte)((fuck&0x00FF0000)>>16);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
            
            tempByte = (Byte)((fuck&0x0000FF00)>>8);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
            
            tempByte = (Byte)(fuck&0x000000FF);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
            
            
        }else{
            
            fuck=videoTagFixLen+[[self.h264NALUArray objectAtIndex:j-1] length];
            
            //  NSLog(@"len:%d",fuck);
            
            tempByte = (Byte)((fuck&0x00FF0000)>>24);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
            
            
            tempByte = (Byte)((fuck&0x00FF0000)>>16);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
            
            tempByte = (Byte)((fuck&0x0000FF00)>>8);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
            
            tempByte = (Byte)(fuck&0x000000FF);
            
            [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
            
            
            
        }
        
        
        tempByte = 0x09;
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        
        fuck=[[self.h264NALUArray objectAtIndex:j] length]+9;
        
        tempByte = (Byte)((fuck&0x00FF0000)>>16);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
        
        tempByte = (Byte)((fuck&0x0000FF00)>>8);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
        
        tempByte = (Byte)(fuck&0x000000FF);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        
        //----
        //定义3个时间戳
        tempByte = (Byte)((time_h&0x00FF0000)>>16);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        tempByte = (Byte)((time_h&0x0000FF00)>>8);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        tempByte =(Byte)(time_h&0x000000FF);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        //备份时间戳
        tempByte = 0x00;
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        
        
        //----
        
        //定义3个3bytes是streamID
        tempByte = 0x00;
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        tempByte = 0x00;
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        tempByte = 0x00;
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
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
        
        fuck=[[self.h264NALUArray objectAtIndex:j] length];
        
        NSLog(@"len:%d",fuck);
        
        tempByte = (Byte)((fuck&0x00FF0000)>>24);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
        
        
        tempByte = (Byte)((fuck&0x00FF0000)>>16);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
        
        tempByte = (Byte)((fuck&0x0000FF00)>>8);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
        
        tempByte = (Byte)(fuck&0x000000FF);
        
        [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
        
        
        
        [flvData appendData:[self.h264NALUArray objectAtIndex:j]];
        
        NSLog(@"===================================");
        
        
        //---------
        time_h=time_h+40;//采样率是11500时候，是40递增，加倍就是80递增
        
    }//for
    //-----------------------
    
    
    
    fuck= videoTagFixLen+ [[self.h264NALUArray objectAtIndex:([self.h264NALUArray count]-1)] length];
    
    //  NSLog(@"len:%d",fuck);
    
    tempByte = (Byte)((fuck&0x00FF0000)>>24);
    
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    
    tempByte = (Byte)((fuck&0x00FF0000)>>16);
    
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//16
    
    tempByte = (Byte)((fuck&0x0000FF00)>>8);
    
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//17
    
    tempByte = (Byte)(fuck&0x000000FF);
    
    [flvData appendBytes:&tempByte length:sizeof(tempByte)];//18
    
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
