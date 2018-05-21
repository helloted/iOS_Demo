//
//  Person.h
//  RuntimeDemo
//
//  Created by Devond on 2016/11/30.
//  Copyright © 2016年 CHZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RuntimeBaseProtocol <NSObject>
@property (nonatomic, strong) NSString *protocolString;
@optional

- (void)doBaseAction;

@end

@protocol RuntimeProtocol <NSObject,RuntimeBaseProtocol>

@optional

- (void)doOptionalAction;

@end

@interface Person : NSObject<RuntimeProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *city;


- (void)runtimeTestAction1;

- (void)runtimeTestAction2;

- (void)runtimeTestAction3;

@end
