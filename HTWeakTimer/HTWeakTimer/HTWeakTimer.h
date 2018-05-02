//
//  HTWeakTimer.h
//  HTWeakTimer
//
//  Created by iMac on 2018/4/23.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTWeakTimer : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* timer;
@end
