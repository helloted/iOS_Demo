//
//  Person.m
//  RuntimeDemo
//
//  Created by Devond on 2016/11/30.
//  Copyright © 2016年 Devond. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)runtimeTestAction1{
    NSLog(@"---%@",NSStringFromSelector(_cmd));
}

- (void)runtimeTestAction2{
    NSLog(@"---%@",NSStringFromSelector(_cmd));
}

- (void)runtimeTestAction3{
    NSLog(@"---%@",NSStringFromSelector(_cmd));
}

@end
