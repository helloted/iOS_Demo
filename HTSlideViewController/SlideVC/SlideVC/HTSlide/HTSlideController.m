//
//  HTSlideController.m
//  SlideVC
//
//  Created by iMac on 2017/10/17.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTSlideController.h"
#import "UIView+HTExtention.h"


@interface HTSlideController ()

@end

@implementation HTSlideController


- (instancetype)initWithMainViewController:(UIViewController *)mainVC sideBarController:(UIViewController *)sideBar{
    if (self = [super init]) {
        _mainVC = mainVC;
        _sideBarVC = sideBar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.mainVC];
    [self addChildViewController:self.sideBarVC];
    
    [self.view addSubview:self.mainVC.view];
    [self.mainVC.view setLeft:0];
    
    [self.view addSubview:self.sideBarVC.view];
    [self.sideBarVC.view setRight:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
