//
//  HTURLGenerator.h
//  NetWorkDemo
//
//  Created by iMac on 2017/9/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetWorkHeader.h"

@interface HTURLGenerator : NSObject

- (NSString *)generateURLStringWithRoute:(HTRequsetRoute)route;

@end
