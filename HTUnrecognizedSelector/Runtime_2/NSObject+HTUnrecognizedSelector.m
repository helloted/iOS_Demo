//
//  NSObject+HTUnrecognizedSelector.m
//  Runtime_2
//
//  Created by iMac on 2018/5/30.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "NSObject+HTUnrecognizedSelector.h"
#import <objc/runtime.h>
#import "HTProxy.h"

static NSString *_errorSelectorName;
void dynamicMethodIMP(id self,SEL _cmd){
#ifdef DEBUG
    NSString *error = [NSString stringWithFormat:@"errorClass->:%@\n errorSelector->%@\n errorReason->UnRecognized Selector",NSStringFromClass([self class]),_errorSelectorName];
    NSLog(@"%@",error);
#else
    //upload error
#endif
    
}
#pragma mark 方法调换

static inline void change_method(Class _originalClass ,SEL _originalSel,Class _newClass ,SEL _newSel){
    Method methodOriginal = class_getInstanceMethod(_originalClass, _originalSel);
    Method methodNew = class_getInstanceMethod(_newClass, _newSel);
    method_exchangeImplementations(methodOriginal, methodNew);
}

@implementation NSObject (HTUnrecognizedSelector)

+ (void)load{
    change_method([self class], @selector(methodSignatureForSelector:), NSClassFromString(@"HTProxy"), @selector(methodSignatureForSelector:));
    change_method([self class], @selector(forwardInvocation:), NSClassFromString(@"HTProxy"), @selector(forwardInvocation:));
}


- (NSMethodSignature *)ht_methodSignatureForSelector:(SEL)aSelector{
    if (![self respondsToSelector:aSelector]) {
        _errorSelectorName = NSStringFromSelector(aSelector);
        class_addMethod([self class], aSelector, (IMP)dynamicMethodIMP, "v@:");
        NSMethodSignature *methodSignature = [self ht_methodSignatureForSelector:aSelector];
        return methodSignature;
    }else{
        return [self ht_methodSignatureForSelector:aSelector];
    }
}

- (void)ht_forwardInvocation:(NSInvocation *)anInvocation{
    SEL selector = [anInvocation selector];
    if ([self respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self];
    }else{
        [self ht_forwardInvocation:anInvocation];
    }
}

@end

