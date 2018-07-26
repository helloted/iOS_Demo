//
//  ViewController.m
//  NetWorkDemo
//
//  Created by iMac on 2017/9/20.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "HTRequest.h"
#import "HTFileClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self uploadFile];
    
//    @try{
//        
//    }@catch(){
//        
//    }@finally{
//        
//    }
//    NSLog(@"request--");
    HTRequest *request = [HTRequest requestRoute:HTRequestRouteVoiceTest];
    request.repeatCount = 1;
    [request sendRequestWithMethod:HTRequsetMethodNormalPOST parameters:nil success:^(id data) {
        NSLog(@"success--data--%@",data);
    } failed:^(NSInteger code, NSString *msg) {
        NSLog(@"---%@",msg);
    }];

    
}

- (void)uploadFile{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"321" ofType:@"png"];
    UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    NSLog(@"%f%f",appleImage.size.height,appleImage.size.width);
    NSData *data = UIImagePNGRepresentation(appleImage);
    HTFileClient *client = [[HTFileClient alloc]init];
    [client postRoute:HTRequestRouteVoiceTest parameters:nil file:data fileName:@"testImage" mimeType:@"image/png" progress:^(float completed, NSProgress *progress) {
        
    } success:^(id data) {
        
    } failed:^(NSInteger code, NSString *msg) {
        
    }];
    
}


- (void)fileDown{
    HTFileClient *client = [[HTFileClient alloc]init];
    NSString *url = @"http://tsho.oss-cn-shenzhen.aliyuncs.com/a.zip";
    [client downloadFileFrom:url progress:^(float completed, NSProgress *progress) {
        NSLog(@"---progress--%f",completed);
    } success:^(NSString *filePath) {
        NSLog(@"file:%@",filePath);
    } failed:^(NSInteger code, NSString *msg) {
        NSLog(@"msg--%@",msg);
    }];
    [client.downloadTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
