//
//  HTImageDownloader.m
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTImageDownloader.h"
#import "HTTool.h"

#define CacheDirectoryPath  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Cache"]

@interface HTImageDownloader()

@property (nonatomic, strong)NSFileManager   *fileManager;
@property (nonatomic, strong)NSCache         *memoryCache;
@property (nonatomic, copy)NSString          *md5URL;

@property (nonatomic, copy)HTImageDownloaderSuccess      successBlock;
@property (nonatomic, copy)HTImageDownloaderFailed       failedBlock;

@end


@implementation HTImageDownloader

- (instancetype)init{
    if ([super init]) {
        _fileManager = [NSFileManager defaultManager];
        _memoryCache = [[NSCache alloc]init];
    }
    return self;
}

- (void)downloadImageWithURL:(NSString *)url cache:(BOOL)cache success:(HTImageDownloaderSuccess)success failed:(HTImageDownloaderFailed)failed{
    self.successBlock = success;
    self.failedBlock = failed;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self queryFromCacheWithURL:url];
    });
}


- (void)queryFromCacheWithURL:(NSString *)url{
    _md5URL = [HTTool md5:url];
    NSData *cacheData = [_memoryCache objectForKey:_md5URL];
    if (cacheData) {//先从缓存中
        [self finishCallWithData:cacheData orError:nil];
    }else{
        NSString *filePath = [CacheDirectoryPath stringByAppendingPathComponent:_md5URL];
        if ([_fileManager fileExistsAtPath:filePath]) {//从硬盘获取
            cacheData = [_fileManager contentsAtPath:filePath];
        }
        if (cacheData) {
            [self finishCallWithData:cacheData orError:nil];
            [_memoryCache setObject:cacheData forKey:cacheData cost:cacheData.length];
        }else{ // 从网络下载
            [self downloadFromNetWithURL:url];
        }
    }
}

- (void)downloadFromNetWithURL:(NSString *)url{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (data) {
            // 存到缓存
            [_memoryCache setObject:data forKey:_md5URL cost:data.length];
            
            // 存到硬盘
            [self storeToDiskWithData:data Md5URL:_md5URL];
        }

        
        // 返回回调
        [self finishCallWithData:data orError:error];
    }];
    [task resume];
}


- (void)storeToDiskWithData:(NSData *)data Md5URL:(NSString *)md5url{
    if (data) {
        if (![_fileManager fileExistsAtPath:CacheDirectoryPath]) {
            [_fileManager createDirectoryAtPath:CacheDirectoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        NSString *filePath = [CacheDirectoryPath stringByAppendingPathComponent:md5url];
        [_fileManager createFileAtPath:filePath contents:data attributes:nil];
    }
}


- (void)finishCallWithData:(NSData *)data orError:(NSError *)error{
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (data && self.successBlock) {
            self.successBlock(data);
        }
        
        if (error && self.failedBlock) {
            self.failedBlock(error);
        }
    });
}

@end
