//
//  RTMPPusher.m
//  RTMPDemo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "RTMPPusher.h"
#import "rtmp.h"
#import "log.h"

@interface RTMPPusher ()

//RTMP连接
@property (nonatomic, assign)RTMP           *rtmp;
@property (nonatomic, copy)NSString         *url;
@property (nonatomic, assign)BOOL           connected;

@end

@implementation RTMPPusher

-(instancetype)init{
    if ([super init]) {
        _connected = NO;
        signal(SIGPIPE, SIG_IGN);
        RTMP_LogSetLevel(RTMP_LOGALL);
        RTMP_LogCallback(rtmpLog);
    }
    return self;
}

#pragma mark RTMP生命周期

- (BOOL)connectWithURL:(NSString *)url{
    _url = url;
    @synchronized (self) {
        _rtmp = [self newRTMP];
        
        char *strUrl = (char *)[url cStringUsingEncoding:NSASCIIStringEncoding];
        if (!RTMP_SetupURL(_rtmp, strUrl)) {
            return NO;
        }
        
        RTMP_EnableWrite(_rtmp);

        if (!RTMP_Connect(_rtmp, NULL) || !RTMP_ConnectStream(_rtmp, 0)) {
            return NO;
        }

        _connected = RTMP_IsConnected(_rtmp);
        return YES;
    }
}


- (RTMP *)newRTMP{
    if (_rtmp) {
        [self closeRTMP];
    }
    
    _rtmp = RTMP_Alloc();
    RTMP_Init(_rtmp);
    return _rtmp;
}

- (void)closeRTMP{
    @synchronized (self) {
        if (_rtmp) {
            RTMP_Close(_rtmp);
            RTMP_Free(_rtmp);
            _rtmp = nil;
        }
    }
}


#pragma mark 写数据

- (void)pushFullVideoData:(NSData *)fullVideo chunkSize:(NSUInteger)size{
    NSUInteger length = [fullVideo length];
    NSUInteger chunkSize = 10 * 5120;
    NSUInteger offset = 0;

    // 将整视频切片后推送
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[fullVideo bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        offset += thisChunkSize;
        [self write:chunk];
        
        sleep(1);
    } while (offset < length);
}

- (NSUInteger)write:(NSData *)data{
    @synchronized (self) {
        int sent = -1;
        if (_connected) {
            NSLog(@"=========%d",(int)[data length]);
            sent = RTMP_Write(_rtmp, [data bytes], (int)[data length]);
        }
        return sent;
    }
}

@end
