//
//  UIView+MY.m
//  Devond
//
//  Created by Devond on 14/12/14.
//  Copyright (c) 2014年 Horace. All rights reserved.
//

#import "UIView+MY.h"

@implementation UIView (MY)

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}



- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setShadowWithOffset:(CGSize)offset{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = 0.2;
}

- (void)setShadowWithOffset:(CGSize)offset withColor:(UIColor *)color{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = 0.5;
}

- (void)moveDistance:(CGFloat)distance direction:(MoveDirection)direction{
    CGPoint point = self.center;
    switch (direction) {
        case MoveDirectionTop:
            point.y -= distance;
            break;
        case MoveDirectionLeft:
            point.x -= distance;
            break;
        case MoveDirectionBottom:
            point.y += distance;
            break;
        case MoveDirectionRight:
            point.x += distance;
            break;
        default:
            break;
    }
    self.center = point;
}

//-(void)drawLineAtPosition:(CGFloat)position leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin
//{
//    LineView *line = [[LineView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
//    [self addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left).offset(leftMargin);
//        make.right.mas_equalTo(self.mas_right).offset(-rightMargin);
//        make.top.mas_equalTo(self.mas_top).offset(self.height * position);
//        make.height.mas_equalTo(1);
//    }];
//}


- (void)rotateCenterWithduration:(CFTimeInterval)duration  fromAngle:(CGFloat)startAngle toAngle:(CGFloat)endAngle{
    CGFloat PIStartAngle = startAngle*M_PI;
    CGFloat PIEndAngle = endAngle*M_PI;
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:PIStartAngle];
    rotationAnimation.toValue = [NSNumber numberWithFloat:PIEndAngle];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
    
//    self.transform = CGAffineTransformRotate(self.transform, PIAngle);
//    self.transform = CGAffineTransform
}


- (void)rotateAtAnchorPoint:(CGPoint)anchorPoint duration:(CFTimeInterval)duration angle:(CGFloat)angle{
    CGFloat PIAngle = angle*M_PI/180;
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:PIAngle];
    rotationAnimation.duration = duration;
    rotationAnimation.removedOnCompletion = NO;
    [CATransaction setCompletionBlock:^{
        self.transform = CGAffineTransformRotate(self.transform, PIAngle);
    }];
    self.layer.anchorPoint = anchorPoint;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
}


- (BOOL)containSubviewWithClass:(Class)clazz {
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:clazz]) {
            return YES;
        } else {
            if ([subView containSubviewWithClass:clazz]) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
