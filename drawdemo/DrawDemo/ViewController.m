//
//  ViewController.m
//  DrawDemo
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "DrawLayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DrawLayer *layer = [[DrawLayer alloc]init];
//    layer.frame = self.view.bounds;
//    [layer setNeedsDisplay];
//    [self.view.layer addSublayer:layer];
    
//    DrawView *view = [[DrawView alloc]initWithFrame:self.view.bounds];
//    view.backgroundColor = [UIColor whiteColor];
//    [view.layer setNeedsDisplay];
//    [self.view addSubview:view];
    
//    [self drawImage];
    
}

- (void)drawImage{
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
//    CGContextRef con = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(con, CGRectMake(0,0,100,100));
//    CGContextSetFillColorWithColor(con, [UIColor orangeColor].CGColor);
//    CGContextFillPath(con);
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [imageView setImage:image];
//    [self.view addSubview:imageView];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100,100), NO, 0);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,100,100)];
    [[UIColor blueColor] setFill];
    [p fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
