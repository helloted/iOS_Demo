//
//  ViewController.m
//  HTMediator
//
//  Created by iMac on 2018/5/31.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "HTMediator.h"
#import "HTMediator+HTOtherModule.h"
#import "URLRouter.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSString *actionName = @"fullOneSentenceWithName:hour:place:doSomething:";
    NSString *result =  [[HTMediator sharedInstance] otherModulePerformAction:actionName name:@"小明" hour:10 place:@"食堂" doSomething:@"吃饭"];
    NSLog(@"result:%@",result);
    
    NSDictionary *dict = @{@"name":@"Jack"};
    [[HTMediator sharedInstance] doWithDict:dict];
    
    // 路由注册
    [URLRouter registerURL:@"MomentViewController"];
    
    // 路由使用
    [URLRouter openURL:@"app://MomentModule/vc/MomentViewController?momentId=10018" handler:^(UIViewController * _Nonnull controller) {
        
    }];
    
    [URLRouter openRoute:@"dnfgamehelper://MomentModule/vc/MomentDetailViewController?momentId=10018&show=1" onVC:self handler:^(NSDictionary * _Nonnull callback) {
        
    }];
    

}

- (void)performDemo{
    Class cls = NSClassFromString(@"HTOtherModule");
    id obj = [[cls alloc]init];
    [obj performSelector:NSSelectorFromString(@"doSomethingWithParameter:") withObject:@"this is the value"];
}

- (void)invotion{
    SEL aSelecotor = NSSelectorFromString(@"doSomethingWithParameter:");
    Class cls = NSClassFromString(@"HTOtherModule");
    id obj = [[cls alloc]init];
    NSMethodSignature * sig  = [cls instanceMethodSignatureForSelector:aSelecotor];
    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sig];
    [invocatin setTarget:obj];
    [invocatin setSelector:aSelecotor];
    NSString *para = @"this is the value";
    [invocatin setArgument:&para atIndex:2];
    [invocatin invoke];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
