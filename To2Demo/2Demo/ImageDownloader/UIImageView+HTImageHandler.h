//
//  UIImageView+HTImageHandler.h
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HTImageViewBlock)(UIImage *image);

@interface UIImageView (HTImageHandler)

- (void)ht_setPlacehodlerImage:(UIImage *)palceholder url:(NSString *)url finish:(HTImageViewBlock)finishBlock;

@end
