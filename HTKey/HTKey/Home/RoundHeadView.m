//
//  RoundHeadView.m
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "RoundHeadView.h"

@interface RoundHeadView()
@property (nonatomic, assign) CGFloat colorPoint;//用户后面计算颜色的随机值
@end

@implementation RoundHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(NSString *)subStringWithLendth:(int)length string:(NSString *)string{
    NSString *copyStr = [string copy];
    NSMutableString *realStr = [[NSMutableString alloc] init];
    
    for(int i = 0; i < copyStr.length; i++){
        if(length == 0){
            break;
        }
        unichar ch = [copyStr characterAtIndex:0];
        if (0x4e00 < ch && ch < 0x9fff)//如何判断是汉字
        {
            //如果是汉子需要做其他处理 可以在这里做处理
        }
        //若为汉字
        [realStr appendString:[copyStr substringWithRange:NSMakeRange(i,1)]];
        
        length = length - 1;
    }
    return realStr;
}

- (CGSize)caculateLableSize{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectZero];
    lable.font = [UIFont fontWithName:@"Arial-BoldMT" size:self.frame.size.width/3.0];
    lable.text = self.title;
    [lable sizeToFit];
    CGSize size = lable.frame.size;
    return size;
}

- (NSString *)pinyin: (NSString *)originalStr{
    NSMutableString *str = [originalStr mutableCopy];
    CFStringTransform(( CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)caculateColor{
    if (_title.length == 0) {
        return;
    }
    if (_title.length>1) {
        NSString *firstStr = [_title substringWithRange:NSMakeRange(0,1)];
        NSString *secondStr = [_title substringWithRange:NSMakeRange(1, 1)];
        NSString *firstPinyin = [self pinyin:firstStr];
        NSString *secondPinyin = [self pinyin:secondStr];
        NSUInteger count = firstPinyin.length+secondPinyin.length;
        if (count>10) {
            count-=10;
            self.colorPoint = count/10.0;
        }else{
            self.colorPoint = count/10.0;
        }
    }else{
        NSString *firstStr = [_title substringWithRange:NSMakeRange(0,1)];
        NSString *firstPinyin = [self pinyin:firstStr];
        NSUInteger count = firstPinyin.length;
        self.colorPoint = count/10.0;
    }
}

-(void)drawRect:(CGRect)rect{
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self caculateColor];//计算颜色
    
    /*画圆*/
    CGContextSetRGBFillColor (context,_colorPoint, 0.5, 0.5, 1.0);//设置填充颜色
    //  CGContextSetRGBStrokeColor(context,red,green,blue,1.0);//画笔线的颜色
    
    //填充圆，无边框
    CGContextAddArc(context, self.frame.size.width/2.0, self.frame.size.width/2.0, self.frame.size.width/2.0, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    
    /*写文字*/
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldMT" size:self.frame.size.width/3.0], NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    CGSize size = [self caculateLableSize];
    CGFloat X = (self.frame.size.width-size.width)/2.0;
    CGFloat Y = (self.frame.size.height-size.height)/2.0;
    [self.title drawInRect:CGRectMake(X, Y, self.frame.size.width, self.frame.size.width) withAttributes:dic];
}


@end
