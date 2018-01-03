//
//  HTTypeDetailViewController.m
//  HTKey
//
//  Created by iMac on 2018/1/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTTypeDetailViewController.h"
#import "HTItemModel.h"
#import "HTItemTableViewCell.h"
#import "AppDelegate.h"
#import "HTItemDetailViewController.h"

@interface HTTypeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView  *tableView;
@property (nonatomic, strong)UIButton     *editBtn;
@property (nonatomic, strong)NSMutableArray *removeArray;
@property (nonatomic, strong)NSMutableArray *removeObjects;


@end

@implementation HTTypeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.isMovingFromParentViewController){
        NSLog(@"pop");
    }else{
        NSLog(@"push");
    }
}

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

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HTItemModel *model = app.items[indexPath.row];
    if (tableView.editing) {
        [self.removeArray addObject:indexPath];
        [self.removeObjects addObject:model];
    }else{
        HTItemDetailViewController *detailVC = [[HTItemDetailViewController alloc]init];
        detailVC.model = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        HTItemModel *model = app.items[indexPath.row];
        [self.removeArray removeObject:indexPath];
        [self.removeObjects removeObject:model];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.allowsMultipleSelectionDuringEditing = YES;
    }
    return _tableView;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(0, 0, 40, 20);
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn bk_addEventHandler:^(id sender) {
            if (!_tableView.editing) {
                [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
                [self.tableView setEditing:YES animated:YES];
                self.removeArray = [NSMutableArray array];
                self.removeObjects = [NSMutableArray array];
            }else{
                [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                [self.tableView setEditing:NO animated:YES];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [self.tableView deleteRowsAtIndexPaths:self.removeArray withRowAnimation:UITableViewRowAnimationLeft];
//                [self.removeObjects enumerateObjectsUsingBlock:^(HTItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [app.items removeObject:model];
//                }];
            }
        } forControlEvents:UIControlEventTouchDown];
    }
    return _editBtn;
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
