//
//  HTImageDownloader.h
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HTImageDownloaderSuccess)(NSData *data);
typedef void(^HTImageDownloaderFailed)(NSError *error);

@interface HTImageDownloader : NSObject

- (void)downloadImageWithURL:(NSString *)url cache:(BOOL)cache success:(HTImageDownloaderSuccess)success failed:(HTImageDownloaderFailed)failed;

@end
