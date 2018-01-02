//
//  BaseDefine.h
//  QRScanner
//
//  Created by Devond on 16/4/29.
//  Copyright © 2016年 Devond. All rights reserved.
//

#ifndef BaseDefine_h
#define BaseDefine_h


#define RGBFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define RGBAFromHex(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:A]

#define DefaultTintColor                     RGBFromHex(0x0FBEEC)
#define DefaultBackGroundColor               RGBFromHex(0xF5F6F7)

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

#define ARRAY_EFFECT(array)  array != nil && ![array isKindOfClass:[NSNull class]] && array.count!= 0

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0f, 1136.0f), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0f, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.0f, 2208.0f), [[UIScreen mainScreen] currentMode].size) : NO)


#define IOSSystemVersion     [[[UIDevice currentDevice] systemVersion] floatValue]

#define IPHONE_WIDTH         [UIScreen mainScreen].bounds.size.width
#define IPHONE_HEIGHT        [UIScreen mainScreen].bounds.size.height

#define LEFTMENU_WIDTH       FitFloat(265)

#define UI_WINDOW            [UIApplication sharedApplication].keyWindow

#define UI_WIDTH             [UIScreen mainScreen].bounds.size.width
#define UI_HEIGHT            ([UIScreen mainScreen].bounds.size.height - kNavBarHeight)
#define TRUE_HEIGHT          ([UIScreen mainScreen].bounds.size.height - kNavBarHeight - kTabbarHeight)

#define kNavBarHeight        64
#define kStatusHeight        20
#define kTabbarHeight        49


#endif /* BaseDefine_h */
