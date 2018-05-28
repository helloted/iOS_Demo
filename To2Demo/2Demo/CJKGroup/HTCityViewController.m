//
//  HTCityViewController.m
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTCityViewController.h"
#import "HTRequest.h"
#import "HTCityModel.h"
#import "NSObject+JsonToModel.h"

static NSString        *cellID = @"HTCityCell";
static NSUInteger      moreCount = 20;

@interface HTCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray     *models;
@property (nonatomic, strong)UITableView        *tableView;
@property (nonatomic, strong)UIButton           *moreBtn;
@property (nonatomic, strong)HTRequest          *request;

@end

@implementation HTCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoading];
    [self requestDataFrom:0 count:moreCount first:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
}

- (void)requestDataFrom:(NSInteger)start count:(NSInteger)count first:(BOOL)first{
    NSString *url = @"https://api.douban.com/v2/loc/list";
    NSDictionary *paras = @{@"start":@(start),@"count":@(count)};
    [self.request getWithURL:url paras:paras success:^(NSDictionary *dict) {
        NSArray *locs = [dict objectForKey:@"locs"];
        [locs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HTCityModel *model = [[HTCityModel alloc]init];
            [model modelWithJsonDictionary:obj];
            [self.models addObject:model];
        }];
        
        if (first) {
            [self hiddenLoading];
            [self.view addSubview:self.tableView];
            self.tableView.tableFooterView = self.moreBtn;
        }
        
        
        if (self.models.count) {
            [self.tableView reloadData];
            NSString *footer = [NSString stringWithFormat:@"点击加载%lu数据(%lu已加载)",(unsigned long)moreCount,(unsigned long)self.models.count];
            [self.moreBtn setTitle:footer forState:UIControlStateNormal];
        }
    } failed:nil];
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FitFloat(50.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HTCityModel *model = self.models[indexPath.row];
    cell.textLabel.text = model.name;
    cell.textLabel.font = [UIFont fontWithName:RegularFontName size:18];
    cell.textLabel.textColor = DefaultGreenColor;
    cell.detailTextLabel.text = model.uid;
    return cell;
}


#pragma mark Selectors

- (void)moreBtnClicked{
    [self requestDataFrom:self.models.count count:moreCount first:NO];
}

- (void)rightBtnClicked{
    [self.models removeAllObjects];
    [self requestDataFrom:self.models.count count:moreCount first:NO];
}

#pragma mark Getter


- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, UI_WIDTH, UI_HEIGHT);
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(0, 0, UI_WIDTH, 36);
        [_moreBtn setTitleColor:DefaultGreenColor forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchDown];
    }
    return _moreBtn;
}

- (HTRequest *)request{
    if (!_request) {
        _request = [[HTRequest alloc]init];
    }
    return _request;
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
