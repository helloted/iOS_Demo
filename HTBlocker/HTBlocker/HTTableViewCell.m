//
//  HTTableViewCell.m
//  HTBlocker
//
//  Created by iMac on 2017/12/14.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTTableViewCell.h"
#import <Masonry/Masonry.h>

#define RGBFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface HTTableViewCell()

@property (nonatomic, strong)UILabel   *label;

@end

@implementation HTTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"HTTableViewCell";
    HTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setNeedsDisplay];
    if (cell == nil) {
        cell = [[HTTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc]init];
        _label.textColor = RGBFromHex(0x666666);
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.equalTo(@30);
        }];
        
        UIImageView *image_1 = [[UIImageView alloc]init];
        [self addSubview:image_1];
        [image_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_label.mas_left);
            make.top.equalTo(_label.mas_bottom).offset(10);
            make.right.equalTo(_label.mas_right);
            make.height.equalTo(@80);
        }];
        image_1.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _label.text = title;
}


@end
