//
//  UIScrollView+HTLoadRefresh.m
//  HTRefresh
//
//  Created by iMac on 2018/5/28.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+HTLoadRefresh.h"
#import <objc/runtime.h>

static CGFloat const SVPullToRefreshViewHeight = 60;

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (HTLoadRefresh)

@dynamic refreshView;

- (void)addLoadRefreshWithActionHandler:(void (^)(void))actionHandler {
    if(!self.refreshView) {
        HTRefreshView *refreshView = [[HTRefreshView alloc] initWithFrame:CGRectMake(0, -SVPullToRefreshViewHeight, self.bounds.size.width, SVPullToRefreshViewHeight)];
        refreshView.pullToRefreshActionHandler = actionHandler;
        refreshView.scrollView = self;
        [self addSubview:refreshView];
        
        refreshView.originalTopInset = self.contentInset.top;
        self.refreshView = refreshView;
        
        [self addObserver:self.refreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self.refreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        self.refreshView.isObserving = YES;
    }
}

- (void)triggerToRefresh{
    [self.refreshView startAnimating];
}

- (void)finishRefresh{
    [self.refreshView stopAnimating];
}

- (void)setRefreshView:(HTRefreshView *)refreshView{
    [self willChangeValueForKey:@"HTRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             refreshView,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"HTRefreshView"];
}

- (HTRefreshView *)refreshView{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}



//+ (void)load {
//    Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
//    Method swizzleMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"su_dealloc"));
//    method_exchangeImplementations(originalMethod, swizzleMethod);
//}
//
//- (void)su_dealloc {
////    self.pullToRefreshView = nil;
//    NSLog(@"scrollew dealloc");
//    [self su_dealloc];
//}

@end



