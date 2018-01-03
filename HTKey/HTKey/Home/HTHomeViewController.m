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
#import "AppDelegate.h"

@interface HTHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic, strong)UIButton   *addBtn;
@property(nonatomic, strong)UIButton   *searchBtn;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UISearchBar *searchBar;

@end

@implementation HTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.addBtn];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return app.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitFloat(70);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemTableViewCell *cell = [HTItemTableViewCell cellWithTableView:tableView];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    cell.model = app.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemDetailViewController *detailVC = [[HTItemDetailViewController alloc]init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    detailVC.model = app.items[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除模型
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.items removeObjectAtIndex:indexPath.row];
    // 刷新
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


#pragma mark UISearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearch];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [self cancelSearch];
    return YES;
}

- (void)cancelSearch{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.addBtn];
    self.navigationItem.titleView = nil;
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
            self.navigationItem.titleView = self.searchBar;
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            [self.searchBar becomeFirstResponder];
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
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.items addObject:newModel];
            HTItemDetailViewController *detailVC = [[HTItemDetailViewController alloc]init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.model = newModel;
            [self.navigationController pushViewController:detailVC animated:YES];
        } forControlEvents:UIControlEventTouchDown];
    }
    return _addBtn;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, UI_WIDTH, kNavBarHeight)];
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
    }
    return _searchBar;
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
