//
//  ViewController.m
//  NilHandle
//
//  Created by Hao on 2019/1/18.
//  Copyright © 2019 Hao. All rights reserved.
//

#import "ViewController.h"
//#import "NSDictionary+ProtectNil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *value = nil;
    NSDictionary *map = @{@"key":value};
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:value forKey:@"hello"];
    
    NSLog(@"finish========");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
