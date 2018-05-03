//
//  IFTimeoutBlock.h
//  rtmp-wrapper
//
//  Created by Min Kim on 2/18/14.
//  Copyright (c) 2014 iFactory Lab Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFTimeoutBlock;

typedef void (^IFTimeoutPeriodicHandler)(IFTimeoutBlock *block);
typedef void (^IFTimeoutHandler)(IFTimeoutBlock *block);
typedef void (^IFExecutionBlock)(IFTimeoutBlock *block);

@interface IFTimeoutBlock : NSObject

- (void)signal;

- (void)waitWithTimeout:(NSUInteger)timeout
        periodicHandler:(IFTimeoutPeriodicHandler)handler;

- (void)setExecuteAsyncWithTimeout:(int)timeout
                       WithHandler:(IFTimeoutHandler)handler
                 andExecutionBlock:(IFExecutionBlock)execution;

@property (assign, nonatomic) BOOL timedOut;

@end
