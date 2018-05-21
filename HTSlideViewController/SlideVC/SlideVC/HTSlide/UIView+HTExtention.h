//
//  UIView+HTExtention.h
//  SlideVC
//
//  Created by iMac on 2017/10/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MoveDirectionTop,
    MoveDirectionLeft,
    MoveDirectionBottom,
    MoveDirectionRight,
} MoveDirection;

@interface UIView (HTExtention)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setTop:(CGFloat)top;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (void)setShadowWithOffset:(CGSize)offset;
- (void)setShadowWithOffset:(CGSize)offset withColor:(UIColor *)color;
- (void)moveDistance:(CGFloat)distance direction:(MoveDirection)direction;

- (void)rotateCenterWithduration:(CFTimeInterval)duration  fromAngle:(CGFloat)startAngle toAngle:(CGFloat)endAngle;

- (void)rotateAtAnchorPoint:(CGPoint)anchorPoint duration:(CFTimeInterval)duration angle:(CGFloat)angle;


@end
