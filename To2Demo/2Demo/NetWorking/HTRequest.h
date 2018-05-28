//
//  HTRequest.h
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//  网络请求类

#import <Foundation/Foundation.h>

typedef void(^HTRequestSuccess)(NSDictionary *reponseDict);
typedef void(^HTRequestFailed)(NSError *error);

@interface HTRequest : NSObject



- (void)getWithURL:(NSString *)url paras:(NSDictionary *)paras success:(HTRequestSuccess)success failed:(HTRequestFailed)failed;

- (void)postWithURL:(NSString *)url paras:(NSDictionary *)paras success:(HTRequestSuccess)success failed:(HTRequestFailed)failed;

@end
