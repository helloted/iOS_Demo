### 一、编译lib库



### 二、使用lib库

因为librtmp用的是C语言，为了方便调用，我用OC封装了一下一个类RTMPPuser。用来推流的代码是

```objc
    RTMPPusher *pusher = [[RTMPPusher alloc]init];
    BOOL success = [pusher connectWithURL:@"rtmp://192.168.0.16:1935/zbcs/room"];
    if (success) {
        NSString *htmlFile = [[NSBundle mainBundle]pathForResource:@"demo" ofType:@"flv"];
        NSData *video = [NSData dataWithContentsOfFile:htmlFile];
        [pusher pushFullVideoData:video chunkSize:10 * 5120];
    }
    [pusher closeRTMP];
```

