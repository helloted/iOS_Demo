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
#import "AppDelegate.h"
#import "HTItemModel.h"
#import "MyDocument.h"

#define UbiquityContainerIdentifier @"iCloud.com.helloted.htkey"

@interface HTMineViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property(nonatomic, strong)UITableView   *tableView;
@property(strong, nonatomic) NSURL *myUrl;
@property(strong,nonatomic) MyDocument  *myDocument;   //icloud数据处理
@property(strong,nonatomic) NSMetadataQuery *myMetadataQuery;//icloud查询需要用这个类

@end

@implementation HTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    //数据获取完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MetadataQueryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:self.myMetadataQuery];
    //文档
    self.myMetadataQuery = [[NSMetadataQuery alloc] init];

}


#pragma mark iCloudKit

//获取最新数据
-(void)downloadDoc{
    [self.myMetadataQuery setSearchScopes:@[NSMetadataQueryUbiquitousDocumentsScope]];
    [self.myMetadataQuery startQuery];
}

//获取成功
-(void)MetadataQueryDidFinishGathering:(NSNotification*)noti{
    NSArray *items = self.myMetadataQuery.results;
    [items enumerateObjectsUsingBlock:^(NSMetadataItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *fileName = [item valueForAttribute:NSMetadataItemFSNameKey];
        //读取文件内容
        MyDocument *doc =[[MyDocument alloc] initWithFileURL:[self getUbiquityContainerUrl:fileName]];
        [doc openWithCompletionHandler:^(BOOL success) {
            if (success) {
                NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:doc.data];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                app.items = [NSMutableArray arrayWithArray:array];
                [SVProgressHUD showSuccessWithStatus:@"下载成功"];
            }
        }];
    }];
}

//获取url
-(NSURL*)getUbiquityContainerUrl:(NSString*)fileName{
    if (!self.myUrl) {
        self.myUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:UbiquityContainerIdentifier];
        if (!self.myUrl) {
            NSLog(@"未开启iCloud功能");
            return nil;
        }
    }
    NSURL *url = [self.myUrl URLByAppendingPathComponent:@"Documents"];
    url = [url URLByAppendingPathComponent:fileName];
    return url;
}

//创建文档并上传
-(void)uploadDoc{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.items.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"当前数量为0，无法上传" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertController addAction:okAction];
        [self presentViewController:alertController animated:NO completion:nil];
        return;
    }
    NSString *fileName =@"back_key";
    NSURL *url = [self getUbiquityContainerUrl:fileName];
    MyDocument *docHandler = [[MyDocument alloc] initWithFileURL:url];
    NSData *back_data = [NSKeyedArchiver archivedDataWithRootObject:app.items];
    docHandler.data = back_data;
    [docHandler saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"上传成功");
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        }
        else{
            NSLog(@"上传失败");
        }
    }];
}


#pragma mark UITableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 3;
    }
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
        cell.textLabel.text = @"邮箱导出";
    }else if (indexPath.section==1&&indexPath.row==1){
        UIImage *original = [UIImage imageNamed:@"download"];
        cell.imageView.image = [HTUtil imageResizeFromImage:original toSize:CGSizeMake(40, 40)];
        cell.textLabel.text = @"从iCloud下载";
    }else{
        UIImage *original = [UIImage imageNamed:@"upload"];
        cell.imageView.image = [HTUtil imageResizeFromImage:original toSize:CGSizeMake(40, 40)];
        cell.textLabel.text = @"上传到iCloud";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1&&indexPath.row==0) {
        [self sendEmailAction];
    }else if (indexPath.section==1&&indexPath.row==1){
        [self downloadDoc];
    }else if (indexPath.section==1&&indexPath.row==2){
        [self uploadDoc];
    }
}

- (void)sendEmailAction
{
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"我的密码导出"];
    // 邮件内容
    [mailCompose setMessageBody:@"我的密码导出备份" isHTML:NO];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"我的密码.txt"];
    
    NSMutableString *result = [NSMutableString string];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.items enumerateObjectsUsingBlock:^(HTItemModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendFormat:@"标题：%@\n",model.title];
        [result appendFormat:@"账号：%@\n",model.account];
        [result appendFormat:@"密码：%@\n",model.password];
        [result appendFormat:@"备注：%@\n",model.remark];
        [result appendString:@"\n"];
    }];
    
    [result appendFormat:@"%@",@"hello"];

    NSError *error;
    [result writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"导出失败:%@",error);
    }else{
        NSLog(@"导出成功");
    }
    NSData *file_data = [NSData dataWithContentsOfFile:path];
    [mailCompose addAttachmentData:file_data mimeType:@"txt" fileName:@"我的密码.txt"];
    
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
