//
//  HTMediator+TargetClass.m
//  HTMediator
//
//  Created by Haozhicao on 2019/8/24.
//  Copyright © 2019 HelloTed. All rights reserved.
//

#import "HTMediator+TargetClass.h"

@implementation HTMediator (TargetClass)

- (CGFloat)momentModuleCheckHeadViewHeightWithType:(NSInteger)type momentId:(NSInteger)momnetId{
    NSString *targetName = @"HTOtherModule";
    NSString *actionName = @"checkHeadViewHeight";
    NSArray *paras = @[@(type),@(momnetId)];
    NSNumber *heightNum = [self performTarget:targetName action:actionName parameters:paras];
    return heightNum.floatValue;
}

- (void)doSomeThingWith:(NSString *)para1 ns:(NSString *)para2{
    __autoreleasing id callBackValue = nil;
    
    Class cls = NSClassFromString(@"TargetClassName");
    id obj = [[cls alloc]init];
    SEL aSelector = NSSelectorFromString(@"doSomethingWithParam1:param2:");
    NSMethodSignature *sig  = [cls instanceMethodSignatureForSelector:aSelector];
    NSInvocation *msgInvocation = [NSInvocation invocationWithMethodSignature:sig];
    [msgInvocation setTarget:obj];
    [msgInvocation setSelector:aSelector];
    [msgInvocation setArgument:&para1 atIndex:2];
    [msgInvocation setArgument:&para2 atIndex:3];
    [msgInvocation invoke];
    [msgInvocation getReturnValue:&callBackValue];
    
}

@end
