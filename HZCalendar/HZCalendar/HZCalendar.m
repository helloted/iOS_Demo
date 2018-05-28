//
//  HZCalendar.m
//  HZCalendar
//
//  Created by Devond on 16/4/14.
//  Copyright © 2016年 HZ. All rights reserved.
//

#import "HZCalendar.h"


static NSString  *CellIdentifier = @"CalendarCell";

@interface HZCalendar ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView        *collectionView;

@property (nonatomic, strong)UIView                  *headerView;

@property (nonatomic, strong)NSMutableArray          *lastMonthDays;
@property (nonatomic, strong)NSMutableArray          *currentMonthDays;
@property (nonatomic, strong)NSMutableArray          *nextMonthDays;

@property (nonatomic, strong)NSDate                  *currentDate;

@property (nonatomic, strong)UIColor                 *tempColor;

@end

@implementation HZCalendar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
        _headerView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_headerView];
        
        
        _currentDate = [NSDate date];
        [self reloadMonthsDaysArray];
        
        
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        [flowLayout setHeaderReferenceSize:CGSizeMake(375, 60)];
        flowLayout.itemSize = CGSizeMake(355/7, 50);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, 375, 320) collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentSize = self.collectionView.frame.size;
        _collectionView.pagingEnabled = YES;
        _collectionView.contentOffset = CGPointMake(0, 320);

        [self addSubview:_collectionView];
        
        
        //注册Cell，必须要有
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return self;
}


- (NSMutableArray *)lastMonthDays{
    if (!_lastMonthDays) {
        _lastMonthDays = [NSMutableArray array];
    }
    return _lastMonthDays;
}

- (NSMutableArray *)currentMonthDays{
    if (!_currentMonthDays) {
        _currentMonthDays = [NSMutableArray array];
    }
    return _currentMonthDays;
}

- (NSMutableArray *)nextMonthDays{
    if (!_nextMonthDays) {
        _nextMonthDays = [NSMutableArray array];
    }
    return _nextMonthDays;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.y+1)/scrollView.frame.size.height;
    if (index == 0) {//往前面
        NSDateComponents *lastComponents = [[NSDateComponents alloc] init];
        lastComponents.month = -1;
        NSDate *lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:lastComponents toDate:_currentDate options:0];
        _currentDate= lastDate;
    }else if (index == 2){
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.month = +1;
        NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:_currentDate options:0];
        _currentDate = nextDate;
    }
    
    [self reloadMonthsDaysArray];
    [_collectionView reloadData];
    self.collectionView.contentOffset = CGPointMake(0, 320);

}





//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.text = self.currentMonthDays[indexPath.row];
    
    switch (indexPath.section) {
        case 0:
            label.text = self.lastMonthDays[indexPath.row];
            break;
        case 1:
            label.text = self.currentMonthDays[indexPath.row];
            break;
        case 2:
            label.text = self.nextMonthDays[indexPath.row];
            break;
        default:
            break;
    }
    
    if (label.text.length) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    }

    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:label];
    
    return cell;
}



/**
 *  本月第一天是星期几
 *
 *  @param date ;
 *
 *  @return ;
 */
- (NSInteger)firstDayInWeakWithDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//1.mon
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

/**
 *  本月有几天
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)daysCountWithDate:(NSDate *)date{
    
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}


- (void)reloadMonthsDaysArray{
    NSDateComponents *lastComponents = [[NSDateComponents alloc] init];
    lastComponents.month = -1;
    NSDate *lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:lastComponents toDate:_currentDate options:0];
    [self resetDaysArray:self.lastMonthDays date:lastDate];
    
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *nextDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:_currentDate options:0];
    
    [self resetDaysArray:self.nextMonthDays date:nextDate];
     
    //显示月份
    [self resetDaysArray:self.currentMonthDays date:_currentDate];
    
}

- (void)resetDaysArray:(NSMutableArray *)array date:(NSDate *)date{
    [array removeAllObjects];
    NSInteger days = [self daysCountWithDate:date];
    NSInteger begin = [self firstDayInWeakWithDate:date];
    for (NSInteger i = 0; i < 42; i ++) {
        if (i <= begin || i > (days + begin)) {
            [array addObject:@""];
        }else{
            [array addObject:[NSString stringWithFormat:@"%ld",(long)(i-begin)]];
        }
    }
}


#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _tempColor = cell.backgroundColor;
    cell.backgroundColor = [UIColor greenColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = _tempColor;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end