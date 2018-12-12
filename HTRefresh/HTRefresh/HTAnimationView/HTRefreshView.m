//
//  HTRefreshView.m
//  HTRefresh
//
//  Created by iMac on 2018/5/28.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "HTRefreshView.h"
#import "UIScrollView+HTLoadRefresh.h"

#define fequalzero(a) (fabs(a) < FLT_EPSILON)

@interface HTRefreshView()

@property (nonatomic, strong) HTArrowView                   *arrow;   // 下拉时的箭头
@property (nonatomic, strong) UIActivityIndicatorView       *activityIndicatorView;  // loading时的菊花
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, assign) HTLoadRefreshState state;

@end


@implementation HTRefreshView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = HTLoadRefreshStateStopped;
        
        self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Pull to refresh...",),
                       NSLocalizedString(@"Release to refresh...",),
                       NSLocalizedString(@"Loading...",),
                       nil];
    }
    
    return self;
}

- (void)layoutSubviews {
    CGFloat remainingWidth = self.superview.bounds.size.width-200;
    float position = 0.50;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = ceilf(remainingWidth*position+44);
    titleFrame.origin.y = self.bounds.size.height-40;
    self.titleLabel.frame = titleFrame;

    
    CGRect arrowFrame = self.arrow.frame;
    arrowFrame.origin.x = ceilf(remainingWidth*position);
    self.arrow.frame = arrowFrame;
    
    self.activityIndicatorView.center = self.arrow.center;
    
    self.titleLabel.text = [self.titles objectAtIndex:self.state];
    
    switch (self.state) {
        case HTLoadRefreshStateStopped:
            self.arrow.alpha = 1;
            [self.activityIndicatorView stopAnimating];
            [self rotateArrow:0 hide:NO];
            break;
            
        case HTLoadRefreshStateTriggered:
            [self rotateArrow:(float)M_PI hide:NO];
            break;
            
        case HTLoadRefreshStateLoading:
            [self.activityIndicatorView startAnimating];
            [self rotateArrow:0 hide:YES];
            break;
        case HTLoadRefreshStateAll:
            break;
    }
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != HTLoadRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalTopInset;
        if(!self.scrollView.isDragging && self.state == HTLoadRefreshStateTriggered)
            self.state = HTLoadRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == HTLoadRefreshStateStopped)
            self.state = HTLoadRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != HTLoadRefreshStateStopped)
            self.state = HTLoadRefreshStateStopped;
    } else {
        CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
        offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
    }
}

#pragma mark - Getters

- (HTArrowView *)arrow {
    if(!_arrow) {
        _arrow = [[HTArrowView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-54, 22, 48)];
        _arrow.backgroundColor = [UIColor clearColor];
        [self addSubview:_arrow];
    }
    return _arrow;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

#pragma mark -

- (void)triggerRefresh {
    [self.scrollView triggerToRefresh];
}

- (void)startAnimating{
    if(fequalzero(self.scrollView.contentOffset.y)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
        self.wasTriggeredByUser = NO;
    }
    else
        self.wasTriggeredByUser = YES;
    
    self.state = HTLoadRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = HTLoadRefreshStateStopped;
    
    if(!self.wasTriggeredByUser && self.scrollView.contentOffset.y < -self.originalTopInset)
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
}

- (void)setState:(HTLoadRefreshState)newState {
    
    if(_state == newState)
        return;
    
    HTLoadRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    
    switch (newState) {
        case HTLoadRefreshStateStopped:
            [self resetScrollViewContentInset];
            break;
            
        case HTLoadRefreshStateTriggered:
            break;
            
        case HTLoadRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            
            if(previousState == HTLoadRefreshStateTriggered && self.pullToRefreshActionHandler)
                self.pullToRefreshActionHandler();
            
            break;
        case HTLoadRefreshStateAll:
            break;
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
        //[self.arrow setNeedsDisplay];//ios 4
    } completion:NULL];
}

- (void)dealloc{
    NSLog(@"refresh view dealloc");
}

@end







@implementation HTArrowView

- (UIColor *)arrowColor {
    if (!_arrowColor) {
        _arrowColor = [UIColor redColor];
    }
    return _arrowColor;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // the rects above the arrow
    CGContextAddRect(c, CGRectMake(5, 0, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 6, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 12, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 18, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 24, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 30, 12, 4));
    
    // the arrow
    CGContextMoveToPoint(c, 0, 34);
    CGContextAddLineToPoint(c, 11, 48);
    CGContextAddLineToPoint(c, 22, 34);
    CGContextAddLineToPoint(c, 0, 34);
    CGContextClosePath(c);
    
    CGContextSaveGState(c);
    CGContextClip(c);
    
    // Gradient Declaration
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat alphaGradientLocations[] = {0, 0.8f};
    
    CGGradientRef alphaGradient = nil;
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 5){
        NSArray* alphaGradientColors = [NSArray arrayWithObjects:
                                        (id)[self.arrowColor colorWithAlphaComponent:0].CGColor,
                                        (id)[self.arrowColor colorWithAlphaComponent:1].CGColor,
                                        nil];
        alphaGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)alphaGradientColors, alphaGradientLocations);
    }else{
        const CGFloat * components = CGColorGetComponents([self.arrowColor CGColor]);
        int numComponents = (int)CGColorGetNumberOfComponents([self.arrowColor CGColor]);
        CGFloat colors[8];
        switch(numComponents){
            case 2:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[0];
                colors[2] = colors[6] = components[0];
                break;
            }
            case 4:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[1];
                colors[2] = colors[6] = components[2];
                break;
            }
        }
        colors[3] = 0;
        colors[7] = 1;
        alphaGradient = CGGradientCreateWithColorComponents(colorSpace,colors,alphaGradientLocations,2);
    }
    CGContextDrawLinearGradient(c, alphaGradient, CGPointZero, CGPointMake(0, rect.size.height), 0);
    CGContextRestoreGState(c);
    CGGradientRelease(alphaGradient);
    CGColorSpaceRelease(colorSpace);
}

@end

