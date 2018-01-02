//
//  HTUtil.h
//  TSho
//
//  Created by iMac on 2017/9/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTUtil : NSObject

extern CGFloat FitFloat(CGFloat f);
extern CGFloat FitArray(NSArray *plist);
extern UIFont *FitFont(CGFloat font);

@end
