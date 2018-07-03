//
//  HTHttpTool.h
//  HTTPServer
//
//  Created by iMac on 2018/7/3.
//  Copyright © 2018年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTHttpTool : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSDictionary *)getIPAddresses;


@end
