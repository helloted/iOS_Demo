//
//  HTRefreshView.h
//  HTRefresh
//
//  Created by iMac on 2018/5/28.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    HTLoadRefreshStateStopped = 0,
    HTLoadRefreshStateTriggered,
    HTLoadRefreshStateLoading,
    HTLoadRefreshStateAll = 10
} HTLoadRefreshState;

@class HTArrowView;

@interface HTRefreshView : UIView

- (void)startAnimating;
- (void)stopAnimating;

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, readwrite) CGFloat originalTopInset;

@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;

@end



@interface HTArrowView : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end
