//
//  ViewController.m
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "HTImageDownloader.h"
#import "UIImageView+HTImageHandler.h"
#import "HTDouBanViewController.h"
#import "HTCJKMainViewController.h"
#import "HTNavigationController.h"
#import "HTCityViewController.h"
#import "HTCJKPhotosViewController.h"
#import "HTTryViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView  *tableView;
@property (nonatomic, copy)NSArray        *section_0_titles;
@property (nonatomic, copy)NSArray        *section_1_titles;
@property (nonatomic, copy)NSArray        *section_1_detailtitles;
@property (nonatomic, copy)NSArray        *movieURLs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else{
        return 8;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, UI_WIDTH, FitFloat(26.0))];
    customView.backgroundColor = RGBFromHex(0xf5f5f5);
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = RGBFromHex(0x444444);
    headerLabel.font = [UIFont fontWithName:RegularFontName size:18];
    headerLabel.frame = CGRectMake(20.0, 0.0, UI_WIDTH, FitFloat(26.0));
    if (section==0) {
        headerLabel.text = @"豆瓣电影";
    }else{
        headerLabel.text = @"其他";
    }
    [customView addSubview:headerLabel];
    return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FitFloat(26);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return FitFloat(40.0);
    }else{
        return FitFloat(50.0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"dou"];
        cell.textLabel.text = self.section_0_titles[indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:RegularFontName size:18];
        cell.textLabel.textColor = RGBFromHex(0x2c651f);
    }else{
        if (indexPath.row < 4) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.section_1_titles[indexPath.row];
            cell.textLabel.textColor = DefaultPurpleColor;
            cell.detailTextLabel.text = self.section_1_detailtitles[indexPath.row];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
            btn.tintColor = RGBFromHex(0x2c651f);
            btn.frame = CGRectMake(UI_WIDTH-FitFloat(50.0), 0,FitFloat(50.0), FitFloat(50.0));
            [cell addSubview:btn];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HTDouBanViewController *douVC = [[HTDouBanViewController alloc]init];
        douVC.title = self.section_0_titles[indexPath.row];
        douVC.requestURL = self.movieURLs[indexPath.row];
        [self.navigationController pushViewController:douVC animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:{
                HTCJKMainViewController *vc = [[HTCJKMainViewController alloc]init];
                vc.title = self.section_1_titles[indexPath.row];
                HTNavigationController *nav = [[HTNavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }break;
            case 1:{
                HTCJKPhotosViewController *vc = [[HTCJKPhotosViewController alloc]init];
                vc.title = self.section_1_titles[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case 2:{
                HTTryViewController *vc = [[HTTryViewController alloc]init];
                vc.title = self.section_1_titles[indexPath.row];
                HTNavigationController *nav = [[HTNavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }break;
            case 3:{
                HTCityViewController *vc = [[HTCityViewController alloc]init];
                vc.title = self.section_1_titles[indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            default:
                break;
        }
    }
}


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


- (NSArray *)movieURLs{
    if (!_movieURLs) {
        NSString *url_0 = @"https://api.douban.com/v2/movie/top250";
        NSString *url_1 = @"https://api.douban.com/v2/movie/in_theaters";
        NSString *url_2 = @"https://api.douban.com/v2/movie/coming_soon";
        _movieURLs = @[url_0,url_1,url_2];
    }
    return _movieURLs;
}


- (NSArray *)section_0_titles{
    if (!_section_0_titles) {
        _section_0_titles = @[@"top250",@"正在热映",@"即将上映"];
    }
    return _section_0_titles;
}

- (NSArray *)section_1_titles{
    if (!_section_1_titles) {
        _section_1_titles = @[@"苍老师主页",@"苍老师相册",@"测试VC",@"城市列表"];
    }
    return _section_1_titles;
}


- (NSArray *)section_1_detailtitles{
    if (!_section_1_detailtitles) {
        _section_1_detailtitles = @[@"Present vc",@"Push vc",@"Present vc",@"Push vc"];
    }
    return _section_1_detailtitles;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
