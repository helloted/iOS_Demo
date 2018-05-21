//
//  HTSlideBaseController.h
//  TSho
//
//  Created by iMac on 2017/9/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSlideBaseController : UIViewController

- (void)moveSideBar;

@end

@interface UIViewController (HTSlideBase)

@property (nonatomic, readonly, strong)HTSlideBaseController   *slideVC;

@end
