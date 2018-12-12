//
//  ViewController.m
//  HTRefresh
//
//  Created by iMac on 2018/5/28.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(200, 200, 50, 50);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(pushBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}


- (void)pushBtnClicked{
    SecondViewController  *second = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:second animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
