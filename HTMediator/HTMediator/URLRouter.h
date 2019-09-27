//
//  URLRouter.h
//  HTMediator
//
//  Created by Haozhicao on 2019/8/26.
//  Copyright © 2019 HelloTed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLRouter : NSObject

+ (void)registerURL:(NSString *)url;

+ (void)openURL:(NSString *)url  handler:(void(^)(UIViewController *controller))block;

+ (void)openRoute:(NSString *)route
                   onVC:(UIViewController *)currentVC
                   handler:(void(^)(NSDictionary *callback))block;
////例：
//[[MKRouterHelper sharedInstance] actionWithRoute:route param:param onVC:self block:^(id result) {
//    NSLog(@"back block : %@",result);
//}];

@end

NS_ASSUME_NONNULL_END
