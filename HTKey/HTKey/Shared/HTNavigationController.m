//
//  HTNavigationController.m
//  TSho
//
//  Created by iMac on 2017/9/16.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTNavigationController.h"

@interface HTNavigationController ()

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
