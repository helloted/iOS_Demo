//
//  ViewController.m
//  HTBlocker
//
//  Created by iMac on 2017/12/13.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "HTTableViewCell.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    

//
//
//    UILabel *label_2 = [[UILabel alloc]init];
//    label_2.textColor = RGBFromHex(0x666666);
//    [self.scrollview addSubview:label_2];
//    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.scrollview.mas_left).offset(20);
//        make.right.equalTo(self.scrollview.mas_right).offset(-20);
//        make.top.equalTo(image_1.mas_bottom).offset(20);
//        make.height.equalTo(@30);
//    }];
//    label_2.text = @"第二步，选择Safari APP";
//
//    UIImageView *image_2 = [[UIImageView alloc]init];
//    [self.scrollview addSubview:image_2];
//    [image_2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(label_1.mas_left);
//        make.top.equalTo(label_2.mas_bottom).offset(10);
//        make.right.equalTo(label_1.mas_right);
//        make.height.equalTo(@100);
//    }];
//    image_2.backgroundColor = [UIColor lightGrayColor];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 120;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTTableViewCell *cell = [HTTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.title = @"第一步，进入设置APP";
    }else if (indexPath.row == 1){
        cell.title = @"第二步，选择Safari APP";
    }else if (indexPath.row == 2){
        cell.title = @"第三步，选择Safari APP";
    }else if (indexPath.row == 3){
        cell.title = @"第四步，选择Safari APP";
    }
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
