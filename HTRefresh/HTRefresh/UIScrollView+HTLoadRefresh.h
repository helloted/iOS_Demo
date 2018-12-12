//
//  UIScrollView+HTLoadRefresh.h
//  HTRefresh
//
//  Created by iMac on 2018/5/28.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTRefreshView.h"

@interface UIScrollView (HTLoadRefresh)

- (void)addLoadRefreshWithActionHandler:(void (^)(void))actionHandler;

// 触发更新
- (void)triggerToRefresh;

// 更新结束或者完成，停止动画
- (void)finishRefresh;

@property (nonatomic, strong)HTRefreshView *refreshView;

@end


