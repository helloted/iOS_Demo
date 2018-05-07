//
//  H264ToFlv.m
//  VTToolbox
//
//  Created by iMac on 2018/5/7.
//  Copyright © 2018年 Ganvir, Manish. All rights reserved.
//

#import "H264ToFlv.h"
#import "RTMPPusher.h"

//#import "Rtmpdump.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>


//网络与本地字节转换
#define HTON16(x)  ((x>>8&0xff)|(x<<8&0xff00))
#define HTON24(x)  ((x>>16&0xff)|(x<<16&0xff0000)|x&0xff00)
#define HTON32(x)  ((x>>24&0xff)|(x>>8&0xff00)|\
(x<<8&0xff0000)|(x<<24&0xff000000))

@interface H264ToFlv()

@property (nonatomic, strong)RTMPPusher   *pusher;

@end

@implementation H264ToFlv


//@synthesize rPublish;

int first1=0;
int topTagLen=16;
int metaFixLen=27;
int first2=0;
int videoLen=0;
int videoTagFixLen=20;

- (id)init {
    if (self = [super init]) {
        
        if(NULL==self.VideoListArray){
            
            self.VideoListArray=[[NSMutableArray alloc] init];
            
        }else{
            
            if([self.VideoListArray count]>0){
                
                [self.VideoListArray removeAllObjects];
            }
        }
    }
    return self;
}

- (void)start{
    [self TestBitFile];
}


-(void)initH264File:(NSString *)path{
    NSInteger fuck = 0;
    NSData * reader = [NSData dataWithContentsOfFile:path];//H264裸数据
    [reader getBytes:&fuck length:sizeof(fuck)];
    Byte *contentByte = (Byte *)[reader bytes];
    NSLog(@"fuck:%ld byte len:%lu",(long)fuck,(unsigned long)[reader length]);
    int count_i=-1;
    Byte kk;
    for(int i=0;i<[reader length];i++){
        if(contentByte[i+0]==0x00&&contentByte[i+1]==0x00&&contentByte[i+2]==0x00&&contentByte[i+3]==0x01){
            i=i+3;
            count_i++;
            [self.VideoListArray addObject:[[NSMutableData alloc] init]];
        }
        else if(contentByte[i+0]==0x00&&contentByte[i+1]==0x00&&contentByte[i+2]==0x00){
            i=i+2;
            count_i++;
            [self.VideoListArray addObject:[[NSMutableData alloc] init]];
        }
        else{
            if(count_i>-1){
                kk=contentByte[i];
                [[self.VideoListArray objectAtIndex:count_i] appendBytes:&kk length:sizeof(kk)];
            }
        }
    }
}

-(void)TestBitFile{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realPath = [documentPath stringByAppendingPathComponent:@"IOSencoder.flv"];
    
    NSString *realPath2 = [[NSBundle mainBundle]pathForResource:@"a" ofType:@"h264"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    
//    if (![fileManager fileExistsAtPath:realPath]){
        [self initH264File:realPath2];
        NSMutableData *writer = [[NSMutableData alloc] init];
        Byte i1 = 0x46;
        [writer appendBytes:&i1 length:sizeof(i1)];//1
        i1 = 0x4C;
        [writer appendBytes:&i1 length:sizeof(i1)];//2
        i1 = 0x56;

        [writer appendBytes:&i1 length:sizeof(i1)];//3

        i1 = 0x01;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//4
        
        i1 = 0x01;//0x01--代表只有视频，0x05-－音频和视频混合，0x04-－只有音频
        
        [writer appendBytes:&i1 length:sizeof(i1)];//5
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//6
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//7
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//8
        
        i1 = 0x09;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//9
        
        
        
        //-----------
        //LAst TAG Head 4
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//10
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//11
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//12
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//13
        
        /**
         0x09前面的00 00 00 00 就是刚刚说的记录着上一个tag的长度的4bytes，这里因为前面没有tag，所以为0
         
         */
        
        //TAG Head 11
        
        /**
         第1个byte为记录着tag的类型，音频（0x8），视频（0x9），脚本（0x12）
         
         */
        
        i1 = 0x09;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//14
        
        
        
        
        //----
        //读取H264文件
        int fuck=topTagLen+[[self.VideoListArray objectAtIndex:0] length]+[[self.VideoListArray objectAtIndex:1] length];
        
        
        // NSLog(@"len:%d",fuck);
        
        
        i1 = (Byte)((fuck&0x00FF0000)>>16);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//16
        
        i1 = (Byte)((fuck&0x0000FF00)>>8);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//17
        
        i1 = (Byte)(fuck&0x000000FF);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        
        //----
        //定义3个时间戳
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        //备份时间戳
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        
        
        //----
        
        //定义3个3bytes是streamID
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        //Meta Tag data
        
        i1 = 0x17;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x00;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        //------------
        
        i1 = 0x01;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x42;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x80;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0x0D;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0xFF;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        i1 = 0xE1;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        
        
        
        i1 = (Byte)(([[self.VideoListArray objectAtIndex:0] length]&0x0000FF00)>>8);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//17
        
        i1 = (Byte)( [[self.VideoListArray objectAtIndex:0] length]&0x000000FF);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        
        [writer appendData:[self.VideoListArray objectAtIndex:0]];
        
        i1 = 0x01;
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        
        i1 = (Byte)(([[self.VideoListArray objectAtIndex:1] length]&0x0000FF00)>>8);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//17
        
        i1 = (Byte)([[self.VideoListArray objectAtIndex:1] length]&0x000000FF);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        [writer appendData:[self.VideoListArray objectAtIndex:1]];
        
        
        
        
        //----------------
        
        int time_h=0;//初始时间戳
        
        for(int j=2;j<[self.VideoListArray count];j++){
            
            if(j==2){
                
                fuck=metaFixLen+[[self.VideoListArray objectAtIndex:0] length]+[[self.VideoListArray objectAtIndex:1] length];
                
                //  NSLog(@"len:%d",fuck);
                
                i1 = (Byte)((fuck&0x00FF0000)>>24);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//16
                
                
                i1 = (Byte)((fuck&0x00FF0000)>>16);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//16
                
                i1 = (Byte)((fuck&0x0000FF00)>>8);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//17
                
                i1 = (Byte)(fuck&0x000000FF);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//18
                
                
            }else{
                
                fuck=videoTagFixLen+[[self.VideoListArray objectAtIndex:j-1] length];
                
                //  NSLog(@"len:%d",fuck);
                
                i1 = (Byte)((fuck&0x00FF0000)>>24);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//16
                
                
                i1 = (Byte)((fuck&0x00FF0000)>>16);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//16
                
                i1 = (Byte)((fuck&0x0000FF00)>>8);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//17
                
                i1 = (Byte)(fuck&0x000000FF);
                
                [writer appendBytes:&i1 length:sizeof(i1)];//18
                
                
                
            }
            
            
            i1 = 0x09;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            
            fuck=[[self.VideoListArray objectAtIndex:j] length]+9;
            
            i1 = (Byte)((fuck&0x00FF0000)>>16);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//16
            
            i1 = (Byte)((fuck&0x0000FF00)>>8);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//17
            
            i1 = (Byte)(fuck&0x000000FF);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            
            //----
            //定义3个时间戳
            i1 = (Byte)((time_h&0x00FF0000)>>16);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            i1 = (Byte)((time_h&0x0000FF00)>>8);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            i1 =(Byte)(time_h&0x000000FF);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            //备份时间戳
            i1 = 0x00;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            
            
            //----
            
            //定义3个3bytes是streamID
            i1 = 0x00;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            i1 = 0x00;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            i1 = 0x00;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            //---------
            
            Byte *contentByte = (Byte *)[[self.VideoListArray objectAtIndex:j] bytes];
            
            if((contentByte[0]& 0x1f) == 5){
                
                i1 = 0x17;
                
                [writer appendBytes:&i1 length:sizeof(i1)];//18
                
            }else{
                
                
                i1 = 0x27;
                
                [writer appendBytes:&i1 length:sizeof(i1)];//18
                
            }
            
            
            i1 = 0x01;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//
            
            //-------
            
            i1 = 0x00;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            i1 = 0x00;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            i1 = 0x00;
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            //--------
            
            fuck=[[self.VideoListArray objectAtIndex:j] length];
            
            NSLog(@"len:%d",fuck);
            
            i1 = (Byte)((fuck&0x00FF0000)>>24);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//16
            
            
            i1 = (Byte)((fuck&0x00FF0000)>>16);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//16
            
            i1 = (Byte)((fuck&0x0000FF00)>>8);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//17
            
            i1 = (Byte)(fuck&0x000000FF);
            
            [writer appendBytes:&i1 length:sizeof(i1)];//18
            
            
            
            [writer appendData:[self.VideoListArray objectAtIndex:j]];
            
            NSLog(@"===================================");
            
            
            //---------
            time_h=time_h+40;//采样率是11500时候，是40递增，加倍就是80递增
            
        }//for
        //-----------------------
        
        
        
        fuck= videoTagFixLen+[[self.VideoListArray objectAtIndex:([self.VideoListArray count]-1)] length];
        
        //  NSLog(@"len:%d",fuck);
        
        i1 = (Byte)((fuck&0x00FF0000)>>24);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//16
        
        
        i1 = (Byte)((fuck&0x00FF0000)>>16);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//16
        
        i1 = (Byte)((fuck&0x0000FF00)>>8);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//17
        
        i1 = (Byte)(fuck&0x000000FF);
        
        [writer appendBytes:&i1 length:sizeof(i1)];//18
        
        
        [writer writeToFile:realPath atomically:YES];
        
        
//    }
    
}

@end
