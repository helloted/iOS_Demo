//
//  HTMineViewController.m
//  HTKey
//
//  Created by iMac on 2017/12/29.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTMineViewController.h"
#import "HTAuthenticaTool.h"
#import <MessageUI/MessageUI.h>

@interface HTMineViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property(nonatomic, strong)UITableView   *tableView;
@property(nonatomic, strong)NSArray       *imageNames;
@property(nonatomic, strong)NSArray       *typeTitles;

@end

@implementation HTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.imageNames = @[@"finger",@"type_pc",@"type_game",@"type_card",@"type_chat",@"type_web",@"type_other"];
    self.typeTitles = @[@"开启指纹验证",@"电脑",@"游戏",@"银行卡/信用卡",@"社交",@"网站",@"其他"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 2;
    }
    return self.imageNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitFloat(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0&&indexPath.row==0) {
        UIImage *original = [UIImage imageNamed:@"finger"];
        cell.imageView.image = [HTUtil imageResizeFromImage:original toSize:CGSizeMake(40, 40)];
        cell.textLabel.text = @"指纹验证保护";
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview bk_addEventHandler:^(id sender) {
            if (switchview.isOn) {
                [HTAuthenticaTool open];
                [SVProgressHUD showSuccessWithStatus:@"开启指纹验证"];
            }else{
                [HTAuthenticaTool close];
            }
        } forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchview;
    }else if (indexPath.section==1&&indexPath.row==0){
        UIImage *original = [UIImage imageNamed:@"mail_bak"];
        cell.imageView.image = [HTUtil imageResizeFromImage:original toSize:CGSizeMake(40, 40)];
        cell.textLabel.text = @"邮箱备份";
    }else{
        UIImage *original = [UIImage imageNamed:@"icloud"];
        cell.imageView.image = [HTUtil imageResizeFromImage:original toSize:CGSizeMake(40, 40)];
        cell.textLabel.text = @"iCloud备份";
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1&&indexPath.row==0) {
        [self sendEmailAction];
    }
}

- (void)sendEmailAction
{
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"我的密码备份"];
    // 邮件内容
    [mailCompose setMessageBody:@"我是邮件内容" isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, UI_WIDTH, TRUE_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
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
