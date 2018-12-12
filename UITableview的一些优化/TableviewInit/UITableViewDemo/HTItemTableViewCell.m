//
//  HTItemTableViewCell.m
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTItemTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HTItemTableViewCell()

@property (nonatomic, strong)UILabel      *contentLabel;
@property (nonatomic, strong)UILabel      *accountView;
@property (nonatomic, strong)NSMutableArray *imgViewArray;


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
        self.contentView.opaque = YES;
        
        // 内容Lablel初始化
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = contentFont;
        _contentLabel.textColor = RGBFromHex(0x666666);
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(contentWidth);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(HTItemCellMargin);
        }];
        
        [self addImageViews];
        
    }
    return self;
}

/*
    橱窗排列的UIimageView添加
 */
- (void)addImageViews{
    CGFloat spaceSize = HTItemCellImageViewSize+HTItemCellImageViewMargin;
    for (int i = 0; i< 9; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.tag = i;
        imgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:imgView];
        [self.imgViewArray addObject:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(i%3*spaceSize+HTItemCellMargin);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(i/3*(spaceSize)+HTItemCellImageViewMargin);
            make.size.mas_equalTo(CGSizeMake(HTItemCellImageViewSize, HTItemCellImageViewSize));
        }];
    }
}


- (void)setModel:(HTItemModel *)model{
    _model = model;
    _contentLabel.text = model.content;
    for (UIImageView *imgView in self.imgViewArray) {
        NSUInteger i = imgView.tag;
        if (i < model.imgArray.count) {
            imgView.hidden = NO;
            [imgView sd_setImageWithURL:model.imgArray[i] placeholderImage:nil options:SDWebImageAvoidAutoSetImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [[NSRunLoop currentRunLoop] performInModes:@[NSDefaultRunLoopMode] block:^{
                        imgView.image = image;
                        NSString *runloopMode = [NSRunLoop currentRunLoop].currentMode;
                        NSLog(@"mode:%@",runloopMode);
                    }];
            }];
        }else{
            imgView.hidden = YES;
        }
    }
}


- (NSMutableArray *)imgViewArray{
    if (!_imgViewArray) {
        _imgViewArray = [NSMutableArray array];
    }
    return _imgViewArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
