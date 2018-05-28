//
//  HTDoubleTableViewCell.m
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTDoubleTableViewCell.h"
#import "UIImageView+HTImageHandler.h"

@interface HTDoubleTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet UILabel *rantLabel;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;

@end

@implementation HTDoubleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"HTDoubleTableViewCell";
    HTDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setNeedsDisplay];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HTDoubleTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)updateWithModel:(HTDoubanModel *)model{
    _titLabel.text = model.title;
    _rantLabel.text = [NSString stringWithFormat:@"评分:%.1f",model.average];
    _markLabel.text = model.mark;
    [_iconView ht_setPlacehodlerImage:[UIImage imageNamed:@"place"] url:model.icon finish:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
