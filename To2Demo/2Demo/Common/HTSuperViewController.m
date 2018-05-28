//
//  HTSuperViewController.m
//  HTKey
//
//  Created by iMac on 2017/12/29.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTSuperViewController.h"

@interface HTSuperViewController ()

@property (nonatomic, strong)UILabel        *loadingLabel;

@end

@implementation HTSuperViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackGroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}


- (UILabel *)loadingLabel{
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 36)];
        _loadingLabel.text = @"正在加载...";
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        _loadingLabel.textColor = DefaultGreenColor;
    }
    return _loadingLabel;
}

- (void)showLoading{
    [self.view addSubview:self.loadingLabel];
}

- (void)hiddenLoading{
    [self.loadingLabel removeFromSuperview];
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
