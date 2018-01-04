//
//  HTTypeViewController.m
//  HTKey
//
//  Created by iMac on 2017/12/29.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTTypeViewController.h"
#import "HTTypeDetailViewController.h"
#import "AppDelegate.h"

@interface HTTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView   *tableView;
@property(nonatomic, strong)NSArray       *imageNames;
@property(nonatomic, strong)NSArray       *typeTitles;

@property(nonatomic, strong)NSMutableDictionary      *countDic;

@end

@implementation HTTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.imageNames = @[@"type_app",@"type_pc",@"type_game",@"type_card",@"type_chat",@"type_web",@"type_other"];
    self.typeTitles = @[@"APP",@"电脑",@"游戏",@"银行卡/信用卡",@"社交",@"网站",@"其他"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *types = [app.items valueForKeyPath:@"@unionOfObjects.type"];
    [self.typeTitles enumerateObjectsUsingBlock:^(NSString *type, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.countDic setValue:@(0) forKey:type];
    }];
    [types enumerateObjectsUsingBlock:^(NSString *type, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger count = [self.countDic integerForKey:type];
        [self.countDic setValue:@(count+1) forKey:type];
    }];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitFloat(70);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    UIImage *original = [UIImage imageNamed:self.imageNames[indexPath.row]];
    cell.imageView.image = [HTUtil imageResizeFromImage:original toSize:CGSizeMake(50, 50)];
    NSString *title = self.typeTitles[indexPath.row];
    NSInteger count = [self.countDic integerForKey:title];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",title,count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTTypeDetailViewController *detailVC = [[HTTypeDetailViewController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.typeName = _typeTitles[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, UI_WIDTH, TRUE_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableDictionary *)countDic{
    if (!_countDic) {
        _countDic = [NSMutableDictionary dictionary];
    }
    return _countDic;
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
