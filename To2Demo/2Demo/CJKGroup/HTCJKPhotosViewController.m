//
//  HTCJKPhotosViewController.m
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTCJKPhotosViewController.h"
#import "UIImageView+HTImageHandler.h"

@interface HTCJKPhotosViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgView;

@end

@implementation HTCJKPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *first = @"https://gss3.bdstatic.com/-Po3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike180%2C5%2C5%2C180%2C60/sign=24fcaed30c0828387c00d446d9f0c264/472309f790529822718d3c0fdcca7bcb0b46d4bb.jpg";
    NSString *second = @"https://gss2.bdstatic.com/-fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike220%2C5%2C5%2C220%2C73/sign=b501aead04b30f242197e451a9fcba26/728da9773912b31b7ed9c8e58d18367adbb4e141.jpg";
    NSString *third = @"https://gss2.bdstatic.com/9fo3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike92%2C5%2C5%2C92%2C30/sign=e0ad791125738bd4d02cba63c0e2ecb3/4a36acaf2edda3cc46c0beec0ae93901203f92d1.jpg";
    [_firstImgView ht_setPlacehodlerImage:[UIImage imageNamed:@"place"] url:first finish:nil];
    [_secondImgView ht_setPlacehodlerImage:[UIImage imageNamed:@"place"] url:second finish:nil];
    [_thirdImgView ht_setPlacehodlerImage:[UIImage imageNamed:@"place"] url:third finish:nil];
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
