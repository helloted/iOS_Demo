//
//  HTItemTableViewCell.m
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTItemTableViewCell.h"
#import "RoundHeadView.h"

@interface HTItemTableViewCell()

@property (nonatomic, strong)RoundHeadView  *iconView;
@property (nonatomic, strong)UILabel      *titleView;
@property (nonatomic, strong)UILabel      *accountView;

@end

@implementation HTItemTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"HTTableViewCell";
    HTItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell setNeedsDisplay];
    if (cell == nil) {
        cell = [[HTItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView  = [[RoundHeadView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _iconView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.left.mas_equalTo(self.mas_left).offset(FitFloat(20));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        _iconView.title = @"默认";
        
        _titleView = [[UILabel alloc]init];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconView.mas_right).offset(10);
            make.top.mas_equalTo(_iconView.mas_top);
            make.height.mas_equalTo(@30);
        }];
        [_titleView setFont:[UIFont boldSystemFontOfSize:18]];
        _titleView.textColor = RGBFromHex(0x333333);
        _titleView.text = @"淘宝";
        
        _accountView = [[UILabel alloc]init];
        [self addSubview:_accountView];
        [_accountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconView.mas_right).offset(10);
            make.bottom.mas_equalTo(_iconView.mas_bottom);
            make.height.mas_equalTo(@20);
        }];
        [_accountView setFont:[UIFont systemFontOfSize:14]];
        _accountView.text = @"chzoffice";
        _accountView.textColor = RGBFromHex(0x999999);
        
    }
    return self;
}

- (void)setModel:(HTItemModel *)model{
    _model = model;
    _titleView.text = _model.title;
    if (_model.title.length < 3) {
        _iconView.title = _model.title;
    }else{
        _iconView.title = [_model.title substringToIndex:2];
    }
    _accountView.text = _model.account;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
