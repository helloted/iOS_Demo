//
//  ViewController.m
//  ObjectiveCPPDemo
//
//  Created by Hao on 2018/8/8.
//  Copyright © 2018年 haozhicao. All rights reserved.
//

#import "ViewController.h"
#import "TargetOC.h"
#include "ReallCpp.hpp"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TargetOC *ocObj = [[TargetOC alloc]init];
    
//    ObjectCpp *cpp = new ObjectCpp((__bridge void*)ocObj,ocObj.ocMethod);
//    cpp->function((__bridge void*)@"123412");
//    delete cpp;
    
    ObjectCpp *cpp = new ObjectCpp;
//    cpp->real_function((__bridge void*)ocObj, (__bridge void*)@"123412");
    
    cpp->call_oc_function((__bridge void*)ocObj,ocObj.doFirstMethod,(__bridge void*)@"this is paras");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
