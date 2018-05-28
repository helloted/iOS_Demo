//
//  HTSingleTableViewCell.m
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTSingleTableViewCell.h"
#import "UIImageView+HTImageHandler.h"

@interface HTSingleTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *dirImgView;
@property (weak, nonatomic) IBOutlet UIImageView *cat_0_View;
@property (weak, nonatomic) IBOutlet UIImageView *cat_1_View;
@property (weak, nonatomic) IBOutlet UIImageView *cat_2_View;
@property (weak, nonatomic) IBOutlet UIImageView *cat_3_View;
@property (weak, nonatomic) IBOutlet UILabel *ratLabel;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;

@end

@implementation HTSingleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"HTSingleTableViewCell";
    HTSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setNeedsDisplay];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HTSingleTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)updateWithModel:(HTDoubanModel *)model{
    _ratLabel.text = [NSString stringWithFormat:@"%.1f",model.average];
    UIImage *palce = [UIImage imageNamed:@"place"];
    _titLabel.text = model.title;
    [_iconView ht_setPlacehodlerImage:palce url:model.icon finish:nil];
    [_dirImgView ht_setPlacehodlerImage:palce url:model.directorImg finish:nil];
    if (model.catsImgs.count) {
        [_cat_0_View ht_setPlacehodlerImage:palce url:model.catsImgs[0] finish:nil];
    }
    
    if (model.catsImgs.count > 1) {
        [_cat_1_View ht_setPlacehodlerImage:palce url:model.catsImgs[1] finish:nil];
    }

    if (model.catsImgs.count > 2) {
        [_cat_2_View ht_setPlacehodlerImage:palce url:model.catsImgs[2] finish:nil];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
