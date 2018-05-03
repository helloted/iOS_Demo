//
//  ViewController.m
//  RTMPDemo
//
//  Created by iMac on 2018/5/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ViewController.h"

#import "RtmpWrapper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RtmpWrapper *rtmp = [[RtmpWrapper alloc] init];
    BOOL ret = [rtmp openWithURL:@"rtmp://192.168.0.16:1935/zbcs/room" enableWrite:YES];
    if (ret) {
        NSString *htmlFile = [[NSBundle mainBundle]pathForResource:@"demo" ofType:@"flv"];
        NSData *video = [NSData dataWithContentsOfFile:htmlFile];
        NSUInteger length = [video length];
        NSUInteger chunkSize = 10 * 5120;
        NSUInteger offset = 0;
        
        // Let's split video to small chunks to publish to media server
        do {
            NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
            NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[video bytes] + offset
                                                 length:thisChunkSize
                                           freeWhenDone:NO];
            offset += thisChunkSize;
            
            // Write new chunk to rtmp server
            [rtmp write:chunk];
            sleep(1);
        } while (offset < length);
    }
    
    // Close rtmp connection and release class object
    [rtmp close];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
