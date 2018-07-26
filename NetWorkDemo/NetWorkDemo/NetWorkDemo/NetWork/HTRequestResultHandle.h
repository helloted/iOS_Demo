//
//  HTRequestResultHandle.h
//  NetWorkDemo
//
//  Created by iMac on 2017/9/29.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRequestResultHandle : NSObject

- (void)handleError:(NSError *)error;

- (void)saveCacheWithURL:(NSString *)url reponse:(id)response;

- (void)searchCacheForURL:(NSString *)url resultBlock:(void (^)(id response))completionHandler;

@end
