//
//  HTChooseTypeViewController.m
//  HTKey
//
//  Created by iMac on 2018/1/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTChooseTypeViewController.h"

@interface HTChooseTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView   *tableView;
@property(nonatomic, strong)NSArray       *imageNames;
@property(nonatomic, strong)NSArray       *typeTitles;

@end

@implementation HTChooseTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择类型";
    [self.view addSubview:self.tableView];
    self.imageNames = @[@"type_app",@"type_pc",@"type_game",@"type_card",@"type_chat",@"type_web",@"type_other"];
    self.typeTitles = @[@"APP",@"电脑",@"游戏",@"银行卡/信用卡",@"社交",@"网站",@"其他"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitFloat(60);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    UIImage *original = [UIImage imageNamed:self.imageNames[indexPath.row]];
    cell.imageView.image = [HTUtil imageResizeFromImage:original toSize:CGSizeMake(40, 40)];
    cell.textLabel.text = self.typeTitles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate &&[self.delegate respondsToSelector:@selector(didSelectType:)]) {
        [self.delegate didSelectType:self.typeTitles[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
