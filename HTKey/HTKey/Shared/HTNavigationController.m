//
//  HTNavigationController.m
//  TSho
//
//  Created by iMac on 2017/9/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTNavigationController.h"

@interface HTNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    //    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    //
    //导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:DefaultTintColor];
    //导航栏按钮颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationBar.translucent = NO;
    //    [[UINavigationBar appearance] setTranslucent:NO];
    
    
    
    
    // 导航栏Title文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:
                                                               [UIColor whiteColor],
                                                           NSFontAttributeName:[UIFont systemFontOfSize:18]
                                                           }];
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:
                                                               [UIColor grayColor],
                                                           NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                           }
     
                                                forState:UIControlStateDisabled];
    // 导航栏左右文字颜色
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:
                                                               [UIColor whiteColor],
                                                           NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                           }
                                                forState:UIControlStateNormal];
//    [self.navigationBar setShadowWithOffset:CGSizeMake(0, 3)];
    
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
