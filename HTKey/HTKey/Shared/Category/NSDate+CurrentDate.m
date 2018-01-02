//
//  NSDate+CurrentDate.m
//  QRScanner
//
//  Created by Devond_iOS on 16/7/9.
//  Copyright © 2016年 Devond. All rights reserved.
//

#import "NSDate+CurrentDate.h"

@implementation NSDate (CurrentDate)
+ (NSString *)getCurrentDate{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY:MM:dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}



@end
