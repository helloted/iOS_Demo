//
//  HTItemTableViewCell.h
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTItemModel.h"

@interface HTItemTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)HTItemModel *model;

@end
