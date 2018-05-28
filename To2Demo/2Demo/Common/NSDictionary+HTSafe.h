//
//  NSDictionary+HTSafe.h
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HTSafe)

- (id)safeObjectForKey:(id)key;

@end
