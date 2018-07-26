//
//  HTFileClient.h
//  NetWorkDemo
//
//  Created by iMac on 2017/9/20.
//  Copyright © 2017年 iMac. All rights reserved.
//  用以上传文件

#import <Foundation/Foundation.h>
#import "HTRequest.h"

typedef void(^HTProgressHandle)(float completed, NSProgress *progress);
typedef void(^HTDownLoadFileSuccess)(NSString *filePath);

@interface HTFileClient : NSObject

@property (nonatomic, strong)NSURLSessionDownloadTask   *downloadTask;
@property (nonatomic, strong)NSURLSessionDataTask       *uploadTask;

- (NSURLSessionDataTask *)postRoute:(HTRequsetRoute)route
                         parameters:(NSDictionary *)paras
                               file:(NSData *)fileData
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           progress:(HTProgressHandle)progress
                            success:(HTRequestSuccess)success
                             failed:(HTRequestFailed)failed;

- (NSURLSessionDownloadTask *)downloadFileFrom:(NSString *)url progress:(HTProgressHandle)progress success:(HTDownLoadFileSuccess)success failed:(HTRequestFailed)failed;

@end
