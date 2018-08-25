//
//  TargetOC.m
//  ObjectiveCPPDemo
//
//  Created by Hao on 2018/8/8.
//  Copyright © 2018年 haozhicao. All rights reserved.
//

#import "TargetOC.h"

void OcObjectDoFirstMethodWithWith(void *ocInstance, void *parameter){
    [(__bridge id)ocInstance doFirstMethodWith:parameter];
}

void OcObjectDoSecondMethodWithWith(void *ocInstance, void *parameter){
    [(__bridge id)ocInstance doSecondMethodWith:parameter];
}

@implementation TargetOC

-(instancetype)init{
    if ([super init]) {
        _doFirstMethod = OcObjectDoFirstMethodWithWith;
    }
    return self;
}

-(void)doFirstMethodWith:(void *)parameter{
    NSLog(@"oc doFirstMethodWith parameter==== %@",parameter);
}

- (void)doSecondMethodWith:(void *)parameter{
    NSLog(@"oc doSecondMethodWith parameter==== %@",parameter);
}

@end
