//
//  ViewController.m
//  RTMPDemo
//
//  Created by iMac on 2018/5/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ViewController.h"

#import "RTMPPusher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RTMPPusher *pusher = [[RTMPPusher alloc]init];
    BOOL success = [pusher connectWithURL:@"rtmp://192.168.0.16:1935/zbcs/room"];
    if (success) {
        NSString *htmlFile = [[NSBundle mainBundle]pathForResource:@"demo" ofType:@"flv"];
        NSData *video = [NSData dataWithContentsOfFile:htmlFile];
        [pusher pushFullVideoData:video chunkSize:10 * 5120];
    }
    [pusher closeRTMP];
    NSLog(@"finish");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
