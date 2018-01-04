//
//  HTItemDetailViewController.m
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTItemDetailViewController.h"

@interface HTItemDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)UITableView  *tableView;
@property (nonatomic, copy)NSArray        *headTitles;
@property (nonatomic, copy)NSArray        *rowCount;
@property (nonatomic, assign)CGFloat      headHeight;
@property (nonatomic, assign)CGFloat      cellHeight;
@property (nonatomic, strong)UIButton     *cancelBtn;
@property (nonatomic, strong)UIButton     *saveBtn;
@property (nonatomic, strong)UIButton     *editBtn;
@property (nonatomic, strong)UITextField  *titleField;
@property (nonatomic, strong)UITextField  *accountField;
@property (nonatomic, strong)UITextField  *passwordField;

@end

@implementation HTItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headTitles = @[@"类型",@"内容",@"备注"];
    _rowCount = @[@1,@3,@1];
    _headHeight = 35;
    _cellHeight = 50;
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:tvc];
    _tableView = tvc.tableView;
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setEdit:(BOOL)edit{
    _edit = edit;
    if (_edit) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.titleField becomeFirstResponder];
    }else{
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editBtn];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, 40, 20);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn bk_addEventHandler:^(id sender) {
            [self cancelBtnClicked];
        } forControlEvents:UIControlEventTouchDown];
    }
    return _cancelBtn;
}

- (void)cancelBtnClicked{
    BOOL title = [_model.title isEqualToString:_titleField.text];
    BOOL account = [_model.account isEqualToString:_accountField.text];
    BOOL password = [_model.password isEqualToString:_passwordField.text];
    if (title && account && password) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"%@,%@",_model.title,_titleField.text);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"保存本次编辑？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self cancelSave];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveData];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:NO completion:nil];
    }
}

- (void)cancelSave{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(0, 0, 40, 20);
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn bk_addEventHandler:^(id sender) {
            [self saveData];
        } forControlEvents:UIControlEventTouchDown];
    }
    return _saveBtn;
}

- (void)saveData{
    self.model.type = @"APP";
    self.model.title = _titleField.text;
    self.model.account = _accountField.text;
    self.model.password = _passwordField.text;
    [self.navigationController popViewControllerAnimated:YES];
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
        CGFloat filedX = FitFloat(70);
        CGFloat copyW = FitFloat(50);
        CGFloat filedW = UI_WIDTH - filedX - copyW;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        [cell addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.right.mas_equalTo(cell.mas_right).offset(-10);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        
        if (indexPath.row==0) {
            cell.textLabel.text = @"标题：";
            _titleField = [[UITextField alloc]initWithFrame:CGRectMake(filedX, 0, filedW, _cellHeight)];
            _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _titleField.placeholder = @"请输入标题...";
            _titleField.text = self.model.title;
            [cell addSubview:_titleField];
            [button bk_addEventHandler:^(id sender) {
                UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string= _titleField.text;
                [SVProgressHUD showSuccessWithStatus:@"已拷贝"];
            } forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row==1){
            cell.textLabel.text = @"账号:";
            _accountField = [[UITextField alloc]initWithFrame:CGRectMake(filedX, 0, filedW, _cellHeight)];
            _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _accountField.placeholder = @"请输入账号...";
            _accountField.text = self.model.account;
            [cell addSubview:_accountField];
            [button bk_addEventHandler:^(id sender) {
                UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string= _accountField.text;
                [SVProgressHUD showSuccessWithStatus:@"已拷贝"];
            } forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row==2){
            cell.textLabel.text = @"密码:";
            _passwordField = [[UITextField alloc]initWithFrame:CGRectMake(filedX, 0, filedW, _cellHeight)];
            _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _passwordField.placeholder = @"请输入账号...";
            _passwordField.text = self.model.password;
            [cell addSubview:_passwordField];
            [button bk_addEventHandler:^(id sender) {
                UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string= _passwordField.text;
                [SVProgressHUD showSuccessWithStatus:@"已拷贝"];
            } forControlEvents:UIControlEventTouchUpInside];
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

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.frame = CGRectMake(0, 0, 40, 20);
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn bk_addEventHandler:^(id sender) {
            self.edit = YES;
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
