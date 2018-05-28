//
//  ViewController.m
//  HZCalendar
//
//  Created by Devond on 16/4/14.
//  Copyright © 2016年 HZ. All rights reserved.
//

#import "ViewController.h"
#import "HZCalendar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HZCalendar *calendar = [[HZCalendar alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:calendar];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
