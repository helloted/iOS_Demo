//
//  HTItemModel.m
//  UITableViewDemo
//
//  Created by iMac on 2018/4/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTItemModel.h"

@interface HTItemModel ()

@property (nonatomic, assign)CGFloat  contentLableHeight;
@property (nonatomic, assign)CGFloat  imageViewArrayHeight;

@end

@implementation HTItemModel

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _content.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _content.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:_content]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    return rect.size;
}

- (void)setContent:(NSString *)content{
    _content = content;
    if (content) {
        CGSize contentSize = [self boundingRectWithSize:CGSizeMake(contentWidth, UI_HEIGHT) font:contentFont lineSpacing:0];
        _contentLableHeight = contentSize.height + HTItemCellMargin;
    }
}

- (void)setImgArray:(NSArray *)imgArray{
    _imgArray = imgArray;
    NSInteger len = imgArray.count;
    if (len==0) {
        _imageViewArrayHeight = 0;
    }else{
        _imageViewArrayHeight = ((len-1)/3 +1)*(HTItemCellImageViewSize + HTItemCellImageViewMargin);
    }
}

- (CGFloat)contentHeight{
    return _contentLableHeight + _imageViewArrayHeight + HTItemCellMargin;
}

//判断如果包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){ int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}


@end
