//
//  HTCJKMainViewController.m
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTCJKMainViewController.h"
#import "UIImageView+HTImageHandler.h"

@interface HTCJKMainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;

@end

@implementation HTCJKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *first = @"https://gss2.bdstatic.com/9fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike116%2C5%2C5%2C116%2C38/sign=3d55cb20da00baa1ae214fe92679d277/d1160924ab18972b766f0606edcd7b899f510aa0.jpg";
    [_firstImgView ht_setPlacehodlerImage:[UIImage imageNamed:@"place"] url:first finish:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClicked)];
}

- (void)leftBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
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
