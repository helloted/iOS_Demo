//
//  HTMediator.m
//  HTMediator
//
//  Created by iMac on 2018/5/31.
//  Copyright © 2018年 HelloTed. All rights reserved.
//  中间件

#import "HTMediator.h"

@implementation HTMediator

+ (instancetype)sharedInstance
{
    static HTMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HTMediator alloc] init];
    });
    return mediator;
}

- (id)performTarget:(NSString *)targetClassName action:(NSString *)actionName parameters:(NSArray *)parameters{
    Class tagetClass = NSClassFromString(targetClassName);
    NSObject *tagert= [[tagetClass alloc]init];
    SEL aSelector = NSSelectorFromString(actionName);
    NSMethodSignature *methodSignature = [tagetClass instanceMethodSignatureForSelector:aSelector];
    if(methodSignature == nil){} // 方法签名找不到，异常情况处理
    else{
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:tagert];
        [invocation setSelector:aSelector];
        
        //消息发送的参数，签名两个是class和selector，所以方法参数从第3个开始
        [parameters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [invocation setArgument:&obj atIndex:idx+2];
        }];
        [invocation invoke];
        
        //返回值处理
        __autoreleasing id callBackObject = nil;
        if(methodSignature.methodReturnLength){
            [invocation getReturnValue:&callBackObject];
        }
        return callBackObject;
    }
    return nil;
}

@end
