//
//  TargetOC.h
//  ObjectiveCPPDemo
//
//  Created by Hao on 2018/8/8.
//  Copyright © 2018年 haozhicao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CppOCBridge.h"

@interface TargetOC : NSObject

- (void)doFirstMethodWith:(void*)parameter;
- (void)doSecondMethodWith:(void *)parameter;

@property interface doFirstMethod;
@property interface doSecondMethod;

@end
