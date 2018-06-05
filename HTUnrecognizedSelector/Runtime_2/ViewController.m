//
//  ViewController.m
//  Runtime_2
//
//  Created by iMac on 2018/5/30.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "ViewController.h"
#import "Demo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Demo *demo = [[Demo alloc]init];
    [demo performSelector:NSSelectorFromString(@"hello")];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
