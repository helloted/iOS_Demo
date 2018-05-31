//
//  HTOtherModule.m
//  HTMediator
//
//  Created by iMac on 2018/5/31.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "HTOtherModule.h"

@implementation HTOtherModule

- (void)doSomethingWithParameter:(NSString *)para{
    NSLog(@"done some with:%@",para);
}

- (NSString *)fullOneSentenceWithName:(NSString *)name hour:(NSNumber *)hour place:(NSString *)palce doSomething:(NSString *)doSomething{
    NSString *full = [NSString stringWithFormat:@"%@%@的时候在%@%@",name,hour,palce,doSomething];
    NSLog(@"full-%@",full);
    return full;
}

@end
