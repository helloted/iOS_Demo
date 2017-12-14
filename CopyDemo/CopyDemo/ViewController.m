//
//  ViewController.m
//  CopyDemo
//
//  Created by iMac on 2017/12/14.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionrealDeepCopy];
}

- (void)copydemo{
    Person *one = [[Person alloc]init];
    one.name = @"ted";
    Person *two = [one copy];
    NSLog(@"%@",two.name);
    NSLog(@"%p,%p",one,two);
}


- (void)valueCopyDemo{
    NSString *str = @"hello";
    NSString *copyStr = [str copy];
    NSString *muCopyStr = [str mutableCopy];
    NSLog(@"str:%p,copy:%p,mycopy%p",str,copyStr,muCopyStr);
}


- (void)collectionCopy{
    NSString *a = @"hello";
    NSString *b = @"world";
    NSArray *someArray = @[a,b];
    NSArray *deepCopyArray= [[NSArray alloc] initWithArray:someArray copyItems:YES];

    NSLog(@"some:%p,deep:%p",someArray,deepCopyArray);
    for (NSString *str in someArray) {
        NSLog(@"some:%p",str);
    }
    
    for (NSString *str in deepCopyArray) {
        NSLog(@"deep:%p",str);
    }
}

- (void)collectionrealDeepCopy{
    NSString *a = @"hello";
    NSString *b = @"world";
    NSArray *someArray = @[a,b];
    NSArray* deepCopyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:someArray]];
    
    NSLog(@"some:%p,deep:%p",someArray,deepCopyArray);
    for (NSString *str in someArray) {
        NSLog(@"some:%p",str);
    }
    
    for (NSString *str in deepCopyArray) {
        NSLog(@"deep:%p",str);
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
