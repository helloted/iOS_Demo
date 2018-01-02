//
//  UITableView+FooterRefresh.m
//  SVPullDemo
//
//  Created by Devond on 16/6/28.
//  Copyright © 2016年 Devond. All rights reserved.
//

#import "UITableView+FooterRefresh.h"
#import <objc/runtime.h>


#define kRefreshViewHeight 50

typedef NS_ENUM(NSInteger, FooterRefreshViewState) {
    FooterRefreshViewStateLoading,
    FooterRefreshViewStatePre,
    FooterRefreshViewStateReady,
};


@interface FooterRefreshView ()

@property (nonatomic, copy) void (^actionHandler)(void);

@property (nonatomic, strong)UITableView                *tableView;

@property (nonatomic, assign)BOOL                       loading;

@property (nonatomic, strong)UIActivityIndicatorView    *activeView;

@property (nonatomic, strong)UILabel                    *showLabel;

@property (nonatomic, assign)FooterRefreshViewState      state;

- (void)updateState:(FooterRefreshViewState)state;

@end


@implementation FooterRefreshView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.activeView];
        self.activeView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        [self addSubview:self.showLabel];
    }
    return self;
}

- (UIActivityIndicatorView *)activeView{
    if (!_activeView) {
        _activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activeView.hidesWhenStopped = YES;
    }
    return _activeView;
}

- (UILabel *)showLabel{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.text = @"Drag up to add more";
    }
    return _showLabel;
}


- (void)updateState:(FooterRefreshViewState)state{
    _state = state;
    switch (state) {
        case FooterRefreshViewStatePre:{
            self.showLabel.hidden = NO;
            self.showLabel.text = @"Drag up to add more";
            [self.activeView stopAnimating];
        }break;
        case FooterRefreshViewStateReady:{
            self.showLabel.hidden = NO;
            self.showLabel.text = @"Realse to add more";
            [self.activeView stopAnimating];
        }break;
        case FooterRefreshViewStateLoading:{
            self.showLabel.hidden = YES;
            [self.activeView startAnimating];
            
        }break;
            
        default:
            break;
    }
}

@end


#pragma mark UITableView
static char UIScrollViewFooterRefreshView;

@implementation UITableView (FooterRefresh)

@dynamic refreshView;

- (void)addFooterRefreshWithActionHandler:(void (^)(void))actionHandler{
    if(!self.refreshView) {
        FooterRefreshView *view = [[FooterRefreshView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, kRefreshViewHeight)];
        view.hidden = YES;
        view.actionHandler = actionHandler;
        view.tableView = self;
        self.refreshView = view;
        [self addSubview:view];
    }
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)setRefreshView:(FooterRefreshView *)refreshView{
    [self willChangeValueForKey:@"UIScrollViewFooterRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewFooterRefreshView,
                             refreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UIScrollViewFooterRefreshView"];
}


- (FooterRefreshView *)refreshView{
    return objc_getAssociatedObject(self, &UIScrollViewFooterRefreshView);
}


- (void)stopAnimation{
    self.refreshView.hidden = YES;
    self.refreshView.frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, kRefreshViewHeight);
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.refreshView.alpha = 0.0;
        self.contentInset = UIEdgeInsetsMake(0 + 0.1, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.refreshView.alpha = 1.0;
        self.refreshView.loading = NO;
        [self.refreshView updateState:FooterRefreshViewStatePre];
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat dragDistance;
        if (self.contentSize.height < self.bounds.size.height) {//xiaoyu
            dragDistance = self.contentOffset.y;
        }else{
            dragDistance = self.contentOffset.y -(self.contentSize.height - CGRectGetHeight(self.frame));
        }
        if (dragDistance > 0) {
            if (self.refreshView.loading) {
                return;
            }
            [self.refreshView updateState:FooterRefreshViewStatePre];
            self.refreshView.hidden = NO;
            self.refreshView.center = CGPointMake(self.center.x, self.contentSize.height + kRefreshViewHeight/2);
            if (dragDistance >  kRefreshViewHeight) {
                if (self.isDragging) {
                    [self.refreshView updateState:FooterRefreshViewStateReady];
                }else{
                    self.refreshView.loading = YES;
                    [self.refreshView updateState:FooterRefreshViewStateLoading];
                    [UIView animateWithDuration:0.2 animations:^{
                        self.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.refreshView.frame), 0);
                    } completion:^(BOOL finished) {
                        self.refreshView.actionHandler();
                    }];
                }// if (dragDistance > 0)
                
            }//if (dragDistance > 0)
        }
        
        if (dragDistance == 0 && self.refreshView.state == FooterRefreshViewStatePre) {
            self.refreshView.hidden = YES;
        }
    }
}


@end
