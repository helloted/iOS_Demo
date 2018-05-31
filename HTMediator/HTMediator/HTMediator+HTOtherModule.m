//
//  HTMediator+HTOtherModule.m
//  HTMediator
//
//  Created by iMac on 2018/5/31.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "HTMediator+HTOtherModule.h"

@implementation HTMediator (HTOtherModule)

- (NSString *)otherModulePerform:(NSString *)targetName action:(NSString *)actionName name:(NSString *)name hour:(NSUInteger)hour place:(NSString *)palce doSomething:(NSString *)doSomething{
    NSNumber *hourNumber = [NSNumber numberWithUnsignedInteger:hour];
    NSArray *paras = @[name,hourNumber,palce,doSomething];
    return [self performTarget:targetName action:actionName parameters:paras];
}

@end
