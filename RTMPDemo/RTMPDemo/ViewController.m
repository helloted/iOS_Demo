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
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong)AVCaptureSession *captureSession;
@property (nonatomic, strong)AVCaptureDeviceInput *currentVideoDeviceInput;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previedLayer;
@property (nonatomic, strong)AVCaptureConnection *videoConnection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self packageH264ToFlv];
//    [self pushFlvToServer];
}

// 捕获音视频
- (void)setupCaputureVideo
{
    // 1.创建捕获会话,必须要强引用，否则会被释放
    _captureSession = [[AVCaptureSession alloc] init];
    
    // 2.获取摄像头设备，默认是后置摄像头
    AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionBack];
    // 3.创建对应视频设备输入对象
    _currentVideoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    
    // 4.获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    // 5.创建对应音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    // 6.添加到会话中
    // 注意“最好要判断是否能添加输入，会话不能添加空的
    // 6.1 添加视频
    if ([_captureSession canAddInput:_currentVideoDeviceInput]) {
        [_captureSession addInput:_currentVideoDeviceInput];
    }
    // 6.2 添加音频
    if ([_captureSession canAddInput:audioDeviceInput]) {
        [_captureSession addInput:audioDeviceInput];
    }
    
    //====================以上是硬件捕获输入====================
    
    
    // 7.获取视频数据输出设备
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    // 7.1 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    if ([_captureSession canAddOutput:videoOutput]) {
        [_captureSession addOutput:videoOutput];
    }
    
    // 8.获取音频数据输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    // 8.2 设置代理，捕获视频样品数据
    // 注意：队列必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([_captureSession canAddOutput:audioOutput]) {
        [_captureSession addOutput:audioOutput];
    }
    
    // 9.获取视频输入与输出连接，用于分辨音视频数据
    _videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 10.添加视频预览图层
    _previedLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _previedLayer.frame = CGRectMake(0, 0, 200, 200);
    [self.view.layer insertSublayer:_previedLayer atIndex:0];
    
    // 11.启动会话
    [_captureSession startRunning];
}

// 指定摄像头方向获取摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
// 获取输入设备数据，有可能是音频有可能是视频
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_videoConnection == connection) {
//        NSData *puv = [self convertVideoSmapleBufferToYuvData:sampleBuffer];
    } else {
        NSLog(@"采集到音频数据");
    }
}

- (void)packageH264ToFlv{
    H264ToFlv *tool = [[H264ToFlv alloc]init];
    [tool start];
}


- (void)pushFlvToServer{
    RTMPPusher *pusher = [[RTMPPusher alloc]init];
    BOOL success = [pusher connectWithURL:@"rtmp://192.168.0.12:1935/zbcs/room"];
    if (success) {
        NSString *htmlFile = [[NSBundle mainBundle]pathForResource:@"d" ofType:@"flv"];
        
//        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *realPath = [documentPath stringByAppendingPathComponent:@"b.flv"];
        
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
