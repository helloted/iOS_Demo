//
//  UITableView+FooterRefresh.h
//  SVPullDemo
//
//  Created by Devond on 16/6/28.
//  Copyright © 2016年 Devond. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FooterRefreshView;

@interface UITableView (FooterRefresh)

- (void)addFooterRefreshWithActionHandler:(void (^)(void))actionHandler;

- (void)stopAnimation;

@property (nonatomic, strong)FooterRefreshView   *refreshView;

@end




@interface FooterRefreshView : UIView

@end
