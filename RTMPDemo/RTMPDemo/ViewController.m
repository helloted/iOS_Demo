//
//  ViewController.m
//  RTMPDemo
//
//  Created by iMac on 2018/5/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "H264ToFlv.h"
#import "RTMPPusher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"po NSHomeDirectory()";
    [self packageH264ToFlv];
//    [self pushFlvToServer];
}

- (void)packageH264ToFlv{
    H264ToFlv *tool = [[H264ToFlv alloc]init];
    [tool start];
}


- (void)pushFlvToServer{
    RTMPPusher *pusher = [[RTMPPusher alloc]init];
    BOOL success = [pusher connectWithURL:@"rtmp://192.168.0.16:1935/zbcs/room"];
    if (success) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *realPath = [documentPath stringByAppendingPathComponent:@"IOSencoder.flv"];
        NSData *video = [NSData dataWithContentsOfFile:realPath];
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
