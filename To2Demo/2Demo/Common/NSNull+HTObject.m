//
//  NSNull+HTObject.m
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "NSNull+HTObject.h"

@implementation NSNull (HTObject)

- (id)objectForKey:(id)key{
    return @"null";
}

@end
