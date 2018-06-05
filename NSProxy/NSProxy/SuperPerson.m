//
//  SuperPerson.m
//  NSProxy
//
//  Created by iMac on 2018/6/5.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "SuperPerson.h"
#import <objc/runtime.h>
#import "Teacher.h"
#import "Worker.h"

@interface SuperPerson () {
    NSMutableDictionary     *_methodsMap;
}
@end

@implementation SuperPerson


#pragma mark - class method
+ (instancetype)person{
    return [[SuperPerson alloc] init];
}

#pragma mark - init
- (instancetype)init{
    _methodsMap = [NSMutableDictionary dictionary];
    Teacher *teacher = [[Teacher alloc] init];
    Worker *worker = [[Worker alloc] init];
    
    // 将"父类"方法继承
    [self inheriteMethodsFromSuperTarget:teacher];
    [self inheriteMethodsFromSuperTarget:worker];
    return self;
}


- (void)inheriteMethodsFromSuperTarget:(id)target{
    unsigned int numberOfMethods = 0;
    Method *method_list = class_copyMethodList([target class], &numberOfMethods);
    for (int i = 0; i < numberOfMethods; i ++) {
        Method temp_method = method_list[i];
        SEL temp_sel = method_getName(temp_method);
        const char *temp_method_name = sel_getName(temp_sel);
        [_methodsMap setObject:target forKey:[NSString stringWithUTF8String:temp_method_name]];
    }
    free(method_list);
}


- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = invocation.selector;
    NSString *methodName = NSStringFromSelector(sel);
    
    //查找对应的target
    id target = _methodsMap[methodName];
    
    if (target && [target respondsToSelector:sel]) {
        [invocation invokeWithTarget:target];
    } else {
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    NSString *methodName = NSStringFromSelector(sel);
    id target = _methodsMap[methodName];
    if (target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}

@end

