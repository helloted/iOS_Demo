//
//  HTTabBarController.m
//  HTKey
//
//  Created by iMac on 2017/12/29.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTTabBarController.h"
#import "HTHomeViewController.h"
#import "HTTypeViewController.h"
#import "HTMineViewController.h"
#import "HTNavigationController.h"

@interface HTTabBarController ()

@end

@implementation HTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    HTHomeViewController *home = [[HTHomeViewController alloc]init];
    home.title = @"首页";
    HTNavigationController *homeNav = [[HTNavigationController alloc]initWithRootViewController:home];
    
    HTTypeViewController *lucky = [[HTTypeViewController alloc]init];
    lucky.title = @"分类";
    HTNavigationController *luckyNav = [[HTNavigationController alloc]initWithRootViewController:lucky];
    
    HTMineViewController *mine = [[HTMineViewController alloc]init];
    mine.title = @"设置";
    HTNavigationController *mineNav = [[HTNavigationController alloc]initWithRootViewController:mine];
    
    self.viewControllers = @[homeNav,luckyNav,mineNav];
    self.tabBar.tintColor = DefaultTintColor;
    self.tabBar.backgroundColor = RGBFromHex(0xfafafa);
    
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *tabBarItem, NSUInteger idx, BOOL *stop) {
        switch (idx) {
            case 0:
            {
                [tabBarItem setImage:[[UIImage imageNamed:@"tab_home_un"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                tabBarItem.tag = 0;
                [tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                break;
            }
            case 1:
            {
                [tabBarItem setImage:[[UIImage imageNamed:@"tyep_unSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                tabBarItem.tag = 1;
                [tabBarItem setSelectedImage:[[UIImage imageNamed:@"tyepSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                break;
            }
            case 2:
            {
                [tabBarItem setImage:[[UIImage imageNamed:@"tab_set_un"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                tabBarItem.tag = 2;
                [tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_set"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                break;
            }
            default:
                break;
        }
        
    }];
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
