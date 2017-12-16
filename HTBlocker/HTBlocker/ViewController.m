//
//  ViewController.m
//  HTBlocker
//
//  Created by iMac on 2017/12/13.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

#define RGBFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define UI_WIDTH    [UIScreen mainScreen].bounds.size.width
#define Margin      20

@interface ViewController ()

@property (nonatomic, strong)UIScrollView    *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    _scrollView.showsVerticalScrollIndicator = NO;
    
    
    UILabel *label_1 = [[UILabel alloc]init];
    label_1.font = [UIFont boldSystemFontOfSize:16];
    label_1.textColor = RGBFromHex(0x444444);
    [_scrollView addSubview:label_1];
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(Margin);
        make.right.equalTo(_scrollView.mas_right).offset(-Margin);
        make.top.equalTo(_scrollView.mas_top).offset(30);
        make.height.equalTo(@30);
    }];
    label_1.text = @"第一步，进入设置";
    
    UIImage *image_1 = [UIImage imageNamed:@"01"];
    UIImageView *imageView_1 = [[UIImageView alloc]initWithImage:image_1];
    imageView_1.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView_1];
    [imageView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_left);
        make.top.equalTo(label_1.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.height.equalTo(@([self convertWithImage:image_1]));
    }];
    

    UILabel *label_2 = [[UILabel alloc]init];
    label_2.font = [UIFont boldSystemFontOfSize:16];
    label_2.textColor = RGBFromHex(0x444444);
    [_scrollView addSubview:label_2];
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(Margin);
        make.right.equalTo(_scrollView.mas_right).offset(-Margin);
        make.top.equalTo(imageView_1.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    label_2.text = @"第二步，选择Safari设置";
    
    UIImage *image_2 = [UIImage imageNamed:@"02"];
    UIImageView *imageView_2 = [[UIImageView alloc]initWithImage:image_2];
    imageView_2.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView_2];
    [imageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_left);
        make.top.equalTo(label_2.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.height.equalTo(@([self convertWithImage:image_2]));
    }];
    
    
    UILabel *label_3 = [[UILabel alloc]init];
    label_3.textColor = RGBFromHex(0x444444);
    label_3.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label_3];
    [label_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(Margin);
        make.right.equalTo(_scrollView.mas_right).offset(-Margin);
        make.top.equalTo(imageView_2.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    label_3.text = @"第三步，选择内容拦截器";
    
    UIImage *image_3 = [UIImage imageNamed:@"03"];
    UIImageView *imageView_3 = [[UIImageView alloc]initWithImage:image_3];
    imageView_3.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView_3];
    [imageView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_left);
        make.top.equalTo(label_3.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.height.equalTo(@([self convertWithImage:image_3]));
    }];
    
    UILabel *label_4 = [[UILabel alloc]init];
    label_4.textColor = RGBFromHex(0x444444);
    label_4.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label_4];
    [label_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(Margin);
        make.right.equalTo(_scrollView.mas_right).offset(-Margin);
        make.top.equalTo(imageView_3.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    label_4.text = @"第四步，打开广告拦截的开关";
    
    UIImage *image_4 = [UIImage imageNamed:@"04"];
    UIImageView *imageView_4 = [[UIImageView alloc]initWithImage:image_4];
    imageView_4.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView_4];
    [imageView_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_1.mas_left);
        make.top.equalTo(label_4.mas_bottom).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-Margin);
        make.height.equalTo(@([self convertWithImage:image_4]));
    }];
    
    
    UILabel *label_5 = [[UILabel alloc]init];
    label_5.textColor = RGBFromHex(0x444444);
    label_5.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:label_5];
    [label_5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(Margin);
        make.right.equalTo(_scrollView.mas_right).offset(-Margin);
        make.top.equalTo(imageView_4.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    label_5.text = @"至此，已经成功拦截浏览器广告";

}

- (CGFloat)convertWithImage:(UIImage *)image{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    return height/width * (UI_WIDTH - 2 * Margin);
}


- (void)viewDidAppear:(BOOL)animated{
   _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, _scrollView.bounds.size.height+1);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
