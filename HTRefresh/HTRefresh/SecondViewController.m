//
//  SecondViewController.m
//  HTRefresh
//
//  Created by iMac on 2018/5/28.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "SecondViewController.h"
#import "UIScrollView+HTLoadRefresh.h"

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView     *tableView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
    
    
    WS(weakself);
    [self.tableView addLoadRefreshWithActionHandler:^{
        NSLog(@"Start to refresh");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.tableView finishRefresh];
        });
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView triggerPullToRefresh];
//    });
    
//    [self.tableView addFooterRefreshWithActionHandler:^{
//        NSLog(@"add more....");
//    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.textLabel.backgroundColor = [UIColor orangeColor];
    return cell;
}


- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = self.view.bounds;
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
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

- (void)dealloc{
    NSLog(@"dealloc===");
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
