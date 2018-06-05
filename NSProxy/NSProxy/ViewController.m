//
//  ViewController.m
//  NSProxy
//
//  Created by iMac on 2018/6/5.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "ViewController.h"
#import "SuperPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [[SuperPerson person] performSelector:NSSelectorFromString(@"workHard")];
    [[SuperPerson person] performSelector:NSSelectorFromString(@"teachStudent")];
#pragma clang diagnostic pop
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
