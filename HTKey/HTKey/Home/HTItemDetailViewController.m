//
//  HTItemDetailViewController.m
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTItemDetailViewController.h"

@interface HTItemDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView  *tableView;
@property (nonatomic, copy)NSArray        *headTitles;
@property (nonatomic, copy)NSArray        *rowCount;
@property (nonatomic, assign)CGFloat      headHeight;
@property (nonatomic, assign)CGFloat      cellHeight;

@end

@implementation HTItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headTitles = @[@"类型",@"内容",@"备注"];
    _rowCount = @[@1,@3,@1];
    _headHeight = 35;
    _cellHeight = 50;
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _headTitles[section];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, _headHeight)];
//    label.text = _headTitles[section];
//    return label;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _headHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSNumber *row = _rowCount[section];
    return row.integerValue;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _headTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =  [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section==0 && indexPath.row ==0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"APP";
    }else if (indexPath.section==1){
        CGFloat filedX = FitFloat(65);
        CGFloat copyW = FitFloat(50);
        CGFloat filedW = UI_WIDTH - filedX - copyW;
        UITextField *filed = [[UITextField alloc]initWithFrame:CGRectMake(filedX, 0, filedW, _cellHeight)];
        filed.clearButtonMode=UITextFieldViewModeWhileEditing;
        [cell addSubview:filed];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [cell addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.right.mas_equalTo(cell.mas_right).offset(-10);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        
        [button bk_addEventHandler:^(id sender) {
            UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string= filed.text;
        } forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row==0) {
            cell.textLabel.text = @"标题:";
            filed.placeholder = @"请输入标题...";
        }else if (indexPath.row==1){
            cell.textLabel.text = @"账号:";
            filed.placeholder = @"请输入账号...";
        }else if (indexPath.row==2){
            cell.textLabel.text = @"密码:";
            filed.placeholder = @"请输入密码...";
        }
    }else if (indexPath.section==2&& indexPath.row==0){
        CGFloat filedX = FitFloat(10);
        CGFloat copyW = FitFloat(50);
        CGFloat filedW = UI_WIDTH - filedX - copyW;
        UITextField *filed = [[UITextField alloc]initWithFrame:CGRectMake(filedX, 0, filedW, _cellHeight)];
        filed.clearButtonMode=UITextFieldViewModeWhileEditing;
        [cell addSubview:filed];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [cell addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.right.mas_equalTo(cell.mas_right).offset(-10);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }
    return cell;
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
