//
//  ViewController.m
//  HTTPServer
//
//  Created by iMac on 2018/7/3.
//  Copyright © 2018年 HT. All rights reserved.
//

#import "ViewController.h"
#import <HTTPServer.h>
#import "HTHTTPConnection.h"
#import "HTHttpTool.h"

@interface ViewController (){
    HTTPServer *httpServer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initServer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedFiles) name:@"ReceivedFileNotification" object:nil];
    
}

 //初始化本地服务器
- (void)initServer {
    httpServer = [[HTTPServer alloc] init];
    [httpServer setPort:8888];
    [httpServer setType:@"_http._tcp."];
    // webPath是server搜寻HTML等文件的路径
    NSString *webPath = [[NSBundle mainBundle] resourcePath];
    [httpServer setDocumentRoot:webPath];
    [httpServer setConnectionClass:[HTHTTPConnection class]];
    NSError *error;
    if ([httpServer start:&error]) {
        NSLog(@"IP: %@:%hu", [HTHttpTool getIPAddress:YES], [httpServer listeningPort]);
    }else {
        NSLog(@"%@", error);
    }
}


- (void)receivedFiles{
    NSLog(@"received files====");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
