//
//  UIImage+Blur.h
//  QRScanner
//
//  Created by Devond on 16/7/1.
//  Copyright © 2016年 Devond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (Blur)

/**
 *  返回模糊效果
 *
 *  @param inputImage            原图
 *  @param blurRadius            模糊程度
 *  @param tintColor             主题色
 *  @param saturationDeltaFactor 图片的灰暗。。。。(待定)
 *  @param maskImage             nil
 *
 *  @return 效果图
 */
+ (UIImage*)imageByApplyingBlurToImage:(UIImage*)inputImage withBlurs:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
