//
//  HTMediator.h
//  HTMediator
//
//  Created by iMac on 2018/5/31.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMediator : NSObject

+ (instancetype)sharedInstance;

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName parameters:(NSArray *)parameters;

@end
