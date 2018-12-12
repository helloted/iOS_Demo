//
//  ViewController.m
//  TextDemo
//
//  Created by iMac on 2017/8/26.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)UITextView     *myTextView;
@property (nonatomic, copy)NSString         *myStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTextView = [[UITextView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.myTextView];
    
//    [self drwaPathview];
    
//    [self useAttachement];
    
}

- (NSString *)myStr{
    if (!_myStr) {
        _myStr = @"If the educational equipment which Gerald brought to America was scant, he did not even know it. Nor would he have cared if he had been told. His mother had taught him to read and to write a clear hand. He was adept at ciphering. And there his book knowledge stopped. The only Latin he knew was the responses of the Mass and the only history the manifold wrongs of Ireland. He knew no poetry save that of Moore and no music except the songs of Ireland that had come down through the years. While he entertained the liveliest respect for those who had more book learning than he, he never felt his own lack. And what need had he of these things in a new country where the most ignorant of bogtrotters had made great fortunes? in this country which asked only that a man be strong and unafraid of work?";
    }
    return _myStr;
}


- (void)drwaPathview{
    self.myTextView.text = self.myStr;
    
    //文字会环绕这个区域来显示
    CGRect rect = CGRectMake(20, 20, 50, 50);
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
    self.myTextView.textContainer.exclusionPaths = @[path];
    
}


- (void)useAttachement{
    UIImage * image = [UIImage imageNamed:@"123"];
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    
    //这个大小，表示图片在View中的大小，也是那一行的大小
    attachment.bounds = CGRectMake(0, 0, 50, 50);
    attachment.image = image;
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]initWithString:self.myStr];
    
    [result insertAttributedString:attachStr atIndex:100];
    self.myTextView.attributedText = result;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
