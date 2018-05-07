//
//  ProxyViewController.m
//  WebProxy
//
//  Created by iMac on 2018/4/18.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ProxyViewController.h"
#import <WebKit/WebKit.h>

@interface ProxyViewController ()


@end

@implementation ProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:@"http://www.swindtech.com/"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
