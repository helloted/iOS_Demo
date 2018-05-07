//
//  ViewController.m
//  WebProxy
//
//  Created by iMac on 2018/4/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "ProxyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

- (void)push{
    ProxyViewController *vc = [[ProxyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
