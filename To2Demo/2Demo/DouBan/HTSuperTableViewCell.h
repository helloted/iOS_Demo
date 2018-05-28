//
//  HTSuperTableViewCell.h
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDoubanModel.h"

@interface HTSuperTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)updateWithModel:(HTDoubanModel *)model;

@end

