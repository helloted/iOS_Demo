//
//  DrawView.m
//  DrawDemo
//
//  Created by iMac on 2017/8/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView


//- (void)drawRect:(CGRect)rect{
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100,100,100,100)];
//    [[UIColor orangeColor] setFill];
//    [path fill];
//}


//- (void)drawRect:(CGRect)rect{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(context, CGRectMake(100,100,100,100));
//    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
//    CGContextFillPath(context);
//}


//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    CGContextAddEllipseInRect(ctx, CGRectMake(100,100,100,100));
//    CGContextSetFillColorWithColor(ctx, [UIColor orangeColor].CGColor);
//    CGContextFillPath(ctx);
//}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    UIGraphicsPushContext(ctx);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100,100,100,100)];
    [[UIColor orangeColor] setFill];
    [p fill];
    UIGraphicsPopContext();
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
