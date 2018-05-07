//
//  RTMPPusher.h
//  RTMPDemo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTMPPusher : NSObject

- (BOOL)connectWithURL:(NSString *)url;
- (void)closeRTMP;

/**
 将一个FLV视频推流到服务器
 
 @param fullVideo 整个视频数据
 @param size 每次传递的大小
 */
- (void)pushFullVideoData:(NSData *)fullVideo chunkSize:(NSUInteger)size;

- (NSUInteger)write:(NSData *)data;

@end
