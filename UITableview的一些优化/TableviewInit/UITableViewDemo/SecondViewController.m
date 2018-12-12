//
//  SecondViewController.m
//  UITableViewDemo
//
//  Created by iMac on 2018/4/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SecondViewController.h"
#import "HTItemTableViewCell.h"
#import "HTItemModel.h"


@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView        *tableView;
@property (nonatomic, strong)NSMutableArray     *modelArray;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self handleNetWorking];

}

- (void)handleNetWorking{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = @"http://39.108.190.11:8050/weibo/list";
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *datas = [responseObject objectForKey:@"data"];
        if (datas && datas.count) {
            for (NSDictionary *weibo in datas) {
                HTItemModel *model = [[HTItemModel alloc]init];
                model.nickIcon = [weibo valueForKey:@"nick_icon"];
                model.nickName = [weibo valueForKey:@"nick_name"];
                model.postTime = [[weibo valueForKey:@"post_time"] integerValue];
                model.upCount = [[weibo valueForKey:@"up_count"] integerValue];
                model.forwardCount = [[weibo valueForKey:@"forward_count"] integerValue];
                model.commentCount = [[weibo valueForKey:@"comment_count"] integerValue];
                model.content = [weibo valueForKey:@"content"];
                model.fromClient = [weibo valueForKey:@"from_client"];
                model.imgArray = [weibo objectForKey:@"img_list"];
                [self.modelArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemModel *model = self.modelArray[indexPath.row];
    return model.contentHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTItemTableViewCell *cell = [HTItemTableViewCell cellWithTableView:tableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}


# pragma mark Getter

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, UI_WIDTH, UI_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
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
