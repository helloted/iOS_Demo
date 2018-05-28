//
//  UIImageView+HTImageHandler.m
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "UIImageView+HTImageHandler.h"
#import "HTImageDownloader.h"

@implementation UIImageView (HTImageHandler)

- (void)ht_setPlacehodlerImage:(UIImage *)palceholder url:(NSString *)url finish:(HTImageViewBlock)finishBlock{
    self.image = palceholder;
    HTImageDownloader *loader = [[HTImageDownloader alloc]init];
    [loader downloadImageWithURL:url cache:YES success:^(NSData *data) {
        UIImage *download = [UIImage imageWithData:data];
        self.image = download;
        if (finishBlock) {
            finishBlock(download);
        }
    } failed:nil];
}

@end
