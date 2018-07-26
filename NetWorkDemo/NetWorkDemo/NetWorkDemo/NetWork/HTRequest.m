//
//  HTRequest.m
//  NetWorkDemo
//
//  Created by iMac on 2017/9/20.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTRequest.h"
#import <AFNetworking.h>
#import "HTURLGenerator.h"
#import "HTRequestResultHandle.h"

static dispatch_queue_t request_complection_handle_queue_get() {
    static dispatch_queue_t request_complection_handle_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request_complection_handle_queue = dispatch_queue_create("HTRequest_complection_handle_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return request_complection_handle_queue;
}

static dispatch_queue_t request_cache_handle_queue_get() {
    static dispatch_queue_t request_cache_handle_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request_cache_handle_queue = dispatch_queue_create("HTRequest_cache_handle_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return request_cache_handle_queue;
}

@interface HTRequest()

@property (nonatomic, copy)HTRequestSuccess             requestSuccess;
@property (nonatomic, copy)HTRequestFailed              requestFailed;
@property (nonatomic, strong)HTRequestResultHandle      *resultHandle;
@property (nonatomic, strong)AFHTTPSessionManager       *manager;
@property (nonatomic, copy)NSString                     *url;

@end


@implementation HTRequest

+ (instancetype)requestRoute:(HTRequsetRoute)route{
    return [[HTRequest alloc]initWithRoute:route];
}

- (instancetype)initWithRoute:(HTRequsetRoute)route{
    if (self = [super init]) {
        self.shouldCache = NO;
        self.timeout = 120;
        self.repeatCount = 0;
        
        self.route = route;
        HTURLGenerator *urlG = [[HTURLGenerator alloc]init];
        self.url = [urlG generateURLStringWithRoute:self.route];
    }
    return self;
}


- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc]init];
        // 继续在异步线程预处理返回结果
        _manager.completionQueue = request_complection_handle_queue_get();
    }
    return _manager;
}


- (NSURLSessionTaskState)state{
    return self.task.state;
}


- (void)cancel{
    NSLog(@"cancel this request");
    [self.task cancel];
}

- (HTRequestResultHandle *)resultHandle{
    if (!_resultHandle) {
        _resultHandle = [[HTRequestResultHandle alloc]init];
    }
    return _resultHandle;
}


- (NSURLSessionDataTask *)sendRequestWithMethod:(HTRequsetMethod)method parameters:(NSDictionary *)paras success:(HTRequestSuccess)success failed:(HTRequestFailed)failed{
    self.requestSuccess = success;
    self.requestFailed = failed;
    self.parameters = paras;
    
    // 结果是否缓存，如果缓存先从缓存中拿
    if (self.shouldCache) {
        dispatch_async(request_cache_handle_queue_get(), ^{
            __weak __typeof__(self) weakSelf = self;
            [self.resultHandle searchCacheForURL:self.url resultBlock:^(id response) {
                [weakSelf successConnectResponseHandle:response];
            }];
        });
        return nil;
    }
    
    switch (method) {
        case HTRequsetMethodNormalGET:{
            self.task = [self normalGetRequestURL:self.url para:self.parameters];
        }break;
        case HTRequsetMethodNormalPOST:{
            self.task = [self normalPOSTRequestURL:self.url para:self.parameters];
        }break;
        case HTRequsetMethodEncryptGET:{
            
        }break;
        case HTRequsetMethodEncryptPOST:{
            
        }break;
        default:
            break;
    }
    return self.task;
}

- (NSURLSessionDataTask *)normalGetRequestURL:(NSString *)url para:(NSDictionary *)paras{
    NSURLSessionDataTask *task = [self.manager GET:url parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self successConnectResponseHandle:responseObject];
        // 缓存
        if (self.shouldCache) {
            [self.resultHandle saveCacheWithURL:url reponse:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failedConnectResponseHandle:task error:error];
    }];
    return task;
}

- (NSURLSessionDataTask *)normalPOSTRequestURL:(NSString *)url para:(NSDictionary *)paras{
    NSURLSessionDataTask *task = [self.manager POST:url parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self successConnectResponseHandle:responseObject];
        // 缓存
        if (self.shouldCache) {
            [self.resultHandle saveCacheWithURL:url reponse:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self failedConnectResponseHandle:task error:error];
    }];
    return task;
}

/**
* 与服务器成功连接,并有结果返回的处理
**/
- (void)successConnectResponseHandle:(id)responseObject{
    NSNumber *codeNum = [responseObject objectForKey:@"code"];
    NSInteger code = [codeNum integerValue];
    if (code == 0) {
        id data = [responseObject objectForKey:@"data"];
        // 成功请求，数据处理完毕后将数据返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.requestSuccess(data);
        });
    }else{
        NSString *msg = [responseObject objectForKey:@"msg"];
        // 与服务器连接成功，但是失败请求，将失败返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.requestFailed(code, msg);
        });
    }
}

/**
 * 与服务器连接失败的处理
 **/
- (void)failedConnectResponseHandle:(NSURLSessionDataTask *)task error:(NSError *)error{
    if (self.repeatCount){
        // 如果设置了失败请求重复，则进行重复请求
        [self normalGetRequestURL:self.url para:self.parameters];
        self.repeatCount -= 1;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"error:%@",error);
            self.requestFailed(1, @"connect server failed");
        });
    }
}

@end
