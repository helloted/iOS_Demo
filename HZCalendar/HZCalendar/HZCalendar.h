//
//  HZCalendar.h
//  HZCalendar
//
//  Created by Devond on 16/4/14.
//  Copyright © 2016年 HZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HZCalendarDelegate <NSObject>

- (void)calendarDidSelectedDate:(NSString *)date;

@end

@interface HZCalendar : UIView


@end
