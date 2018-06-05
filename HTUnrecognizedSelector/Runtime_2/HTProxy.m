//
//  HTProxy.m
//  Runtime_2
//
//  Created by iMac on 2018/6/4.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "HTProxy.h"
#import <objc/runtime.h>

static NSString *_errorSelectorName;
void proxyDynamicMethodIMP(id self,SEL _cmd){
#ifdef DEBUG
    NSString *error = [NSString stringWithFormat:@"errorClass->:%@\n errorSelector->%@\n errorReason->UnRecognized Selector",NSStringFromClass([self class]),_errorSelectorName];
    NSLog(@"proxy:%@",error);
#else
    // 上报错误日志
#endif
}

@implementation HTProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (![self respondsToSelector:aSelector]) {
        _errorSelectorName = NSStringFromSelector(aSelector);
        class_addMethod([self class], aSelector, (IMP)proxyDynamicMethodIMP, "v@:");
    }
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:aSelector];
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL selector = [anInvocation selector];
    if ([self respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self];
    }else{
        [self forwardInvocation:anInvocation];
    }
}

@end
