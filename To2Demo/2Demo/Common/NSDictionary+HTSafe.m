//
//  NSDictionary+HTSafe.m
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "NSDictionary+HTSafe.h"

@implementation NSDictionary (HTSafe)

- (id)safeObjectForKey:(id)key{
    if (![self isKindOfClass:[NSDictionary class]]) {
        NSLog(@"not classss");
        return nil;
    }else{
        return [self objectForKey:key];
    }
}

@end
