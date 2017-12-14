//
//  Person.h
//  CopyDemo
//
//  Created by iMac on 2017/12/14.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy)NSString   *name;
@property (nonatomic, assign)NSUInteger  *age;

@end
