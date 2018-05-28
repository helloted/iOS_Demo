//
//  HTRequest.m
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTRequest.h"

@interface HTRequest()
@property (nonatomic, strong)NSURLSession *session;
@end
@implementation HTRequest

- (instancetype)init{
    if ([super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)getWithURL:(NSString *)url paras:(NSDictionary *)paras success:(HTRequestSuccess)success failed:(HTRequestFailed)failed{
    NSMutableString *mutalbeURL = [NSMutableString stringWithString:url];
    if (paras) {
        [mutalbeURL appendString:@"?"];
        [paras enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *valueStr = [NSString stringWithFormat:@"%@=%@&",key,obj];
            [mutalbeURL appendString:valueStr];
        }];
    }
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:mutalbeURL]];
    if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
        [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    mutableRequest.HTTPMethod = @"GET";
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (dic && success) {
                success(dic);
            }else{
                failed(error);
            }
        });
    }];
    [task resume];
}

- (void)postWithURL:(NSString *)url paras:(NSDictionary *)paras success:(HTRequestSuccess)success failed:(HTRequestFailed)failed{
    NSMutableString *mutalbeURL = [NSMutableString stringWithString:url];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:mutalbeURL]];
    if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
        [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    mutableRequest.HTTPMethod = @"POST";
    
    NSData *postDatas = [NSJSONSerialization dataWithJSONObject:paras options:NSJSONWritingPrettyPrinted error:nil];
    mutableRequest.HTTPBody = postDatas;
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (dic && success) {
                success(dic);
            }else{
                failed(error);
            }
        });
    }];
    [task resume];
}

@end
