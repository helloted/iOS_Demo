//
//  HTRequest.h
//  NetWorkDemo
//
//  Created by iMac on 2017/9/20.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetWorkHeader.h"
#import "HTNetWorkEnum.h"

typedef void(^HTRequestSuccess)(id data);
typedef void(^HTRequestFailed)(NSInteger code,NSString *msg);

@interface HTRequest : NSObject

/**
   超时时间，默认120S
 */
@property (nonatomic, assign)NSUInteger      timeout;


/**
   是否对下载结果缓存，默认为NO
 */
@property (nonatomic, assign)BOOL            shouldCache;

/**
   失败连接后的再次请求重复次数，默认为0,不重复
 */
@property (nonatomic, assign)NSUInteger      repeatCount;

/**
   请求路径
 */
@property (nonatomic, assign)HTRequsetRoute  route;

/**
   请求的参数
 */
@property (nonatomic, strong)NSDictionary    *parameters;

/**
   当前请求Task
 */
@property (nonatomic, strong)NSURLSessionDataTask      *task;


/**
   当前请求Task的状态
 */
@property (readonly) NSURLSessionTaskState state;


// 初始化
- (instancetype)initWithRoute:(HTRequsetRoute)route;
+ (instancetype)requestRoute:(HTRequsetRoute)route;

// 请求取消
- (void)cancel;

// 发送请求
- (NSURLSessionDataTask *)sendRequestWithMethod:(HTRequsetMethod)method parameters:(NSDictionary *)paras success:(HTRequestSuccess)success failed:(HTRequestFailed)failed;

@end
