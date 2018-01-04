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
@property (nonatomic, strong)UIButton     *addBtn;
@property (nonatomic, strong)NSMutableArray *sourceArray;

@end

@implementation HTTypeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.items enumerateObjectsUsingBlock:^(HTItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.type isEqualToString:self.typeName]) {
            [self.sourceArray addObject:model];
        }
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.addBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.isMovingFromParentViewController){
        NSLog(@"pop");
    }else{
        NSLog(@"push");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitFloat(70);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemTableViewCell *cell = [HTItemTableViewCell cellWithTableView:tableView];
    cell.model = _sourceArray[indexPath.row];
    return cell;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemDetailViewController *detailVC = [[HTItemDetailViewController alloc]init];
    detailVC.model = _sourceArray[indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.edit = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            detailVC.edit = YES;
            detailVC.model = newModel;
            [self.navigationController pushViewController:detailVC animated:YES];
        } forControlEvents:UIControlEventTouchDown];
    }
    return _addBtn;
}

- (NSMutableArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
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
