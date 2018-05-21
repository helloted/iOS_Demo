//
//  HTMainViewController.m
//  SlideVC
//
//  Created by iMac on 2017/10/17.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTMainViewController.h"
#import "HTSlideBaseController.h"

@interface HTMainViewController ()

@end

@implementation HTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"items"] style:UIBarButtonItemStylePlain target:self action:@selector(moveLeftMenuAction)];
}

- (void)moveLeftMenuAction{
    [self.slideVC moveSideBar];
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
