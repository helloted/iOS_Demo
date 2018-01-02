//
//  UIWindow+MY.m
//  QRScanner
//
//  Created by Devond_iOS on 16/6/22.
//  Copyright © 2016年 Devond. All rights reserved.
//

#import "UIWindow+MY.h"

@implementation UIWindow (MY)

+(UIWindow *)getCurrentWindow:(UIView *)currentView{
  
    while (currentView.superview) {
        if ([currentView.superview isKindOfClass:[UIWindow class]]) {
            break;
        }
        currentView = currentView.superview;
    }
    return (UIWindow *)currentView.superview;
}

@end
