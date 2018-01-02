//
//  HTHomeViewController.m
//  HTKey
//
//  Created by iMac on 2017/12/29.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTHomeViewController.h"
#import "HTItemTableViewCell.h"
#import "HTItemDetailViewController.h"

@interface HTHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UIButton   *addBtn;
@property(nonatomic, strong)UIButton   *searchBtn;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray   *items;

@end

@implementation HTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.addBtn];
    [self.view addSubview:self.tableView];
    [self unArchiverAllData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(archiverAllData) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)archiverAllData{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"all"];
    [NSKeyedArchiver archiveRootObject:self.items toFile:file];
}

- (void)unArchiverAllData{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"all"];
    self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitFloat(70);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemTableViewCell *cell = [HTItemTableViewCell cellWithTableView:tableView];
    cell.model = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemDetailViewController *detailVC = [[HTItemDetailViewController alloc]init];
    detailVC.model = self.items[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    [self.items removeObjectAtIndex:indexPath.row];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

/**
 *  修改Delete按钮文字为“删除”
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark Getter

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, UI_WIDTH, TRUE_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, FitFloat(20), FitFloat(20));
        [_searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchBtn bk_addEventHandler:^(id sender) {
            [self archiverAllData];
        } forControlEvents:UIControlEventTouchDown];
    }
    return _searchBtn;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(0, 0, FitFloat(20), FitFloat(20));
        [_addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [_addBtn bk_addEventHandler:^(id sender) {
            HTItemModel *newModel = [[HTItemModel alloc]init];
            [self.items addObject:newModel];
            HTItemDetailViewController *detailVC = [[HTItemDetailViewController alloc]init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.model = newModel;
            [self.navigationController pushViewController:detailVC animated:YES];
        } forControlEvents:UIControlEventTouchDown];
    }
    return _addBtn;
}

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
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
