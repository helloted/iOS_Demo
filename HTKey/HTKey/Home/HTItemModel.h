//
//  HTItemModel.h
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTItemModel : NSObject <NSCoding>

@property (nonatomic, copy)NSString    *type;
@property (nonatomic, copy)NSString    *title;
@property (nonatomic, copy)NSString    *account;
@property (nonatomic, copy)NSString    *password;
@property (nonatomic, copy)NSString    *remark;

@end
