//
//  HTFileClient.m
//  NetWorkDemo
//
//  Created by iMac on 2017/9/20.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTFileClient.h"
#import <AFNetworking.h>
#import "HTURLGenerator.h"


@implementation HTFileClient

- (NSURLSessionDataTask *)postRoute:(HTRequsetRoute)route parameters:(NSDictionary *)paras file:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(HTProgressHandle)progress success:(HTRequestSuccess)success failed:(HTRequestFailed)failed{
    HTURLGenerator *urlG = [[HTURLGenerator alloc]init];
    NSString *url = [urlG generateURLStringWithRoute:route];
    if (!fileName) {
        fileName = @"";
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDataTask *task = [manager POST:url parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response--%@",responseObject);
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code = [codeNum integerValue];
        if (code == 0) {
            id data = [responseObject objectForKey:@"data"];
            // 成功请求，数据处理完毕后将数据返回主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                success(data);
            });
        }else{
            NSString *msg = [responseObject objectForKey:@"msg"];
            // 与服务器连接成功，但是失败请求，将失败返回主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(code, msg);
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error--%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            failed(1, @"connect server failed");
        });
    }];
    return task;
}

- (NSURLSessionDownloadTask *)downloadFileFrom:(NSString *)url progress:(HTProgressHandle)progress success:(HTDownLoadFileSuccess)success failed:(HTRequestFailed)failed{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.fractionCompleted,downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failed(2,@"Net work error");
        }else{
            success([filePath path]);
        }
    }];
    return self.downloadTask;
}


@end
