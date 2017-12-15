//
//  HTTableViewCell.h
//  HTBlocker
//
//  Created by iMac on 2017/12/14.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy)NSString   *title;

@property (nonatomic, strong)UIImage  *image;

@end
