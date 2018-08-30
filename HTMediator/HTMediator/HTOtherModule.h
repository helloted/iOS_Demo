//
//  HTOtherModule.h
//  HTMediator
//
//  Created by iMac on 2018/5/31.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTOtherModule : NSObject

- (void)doSomethingWithParameter:(NSString *)para;

- (void)doWithDict:(NSDictionary *)dict;

- (NSString *)fullOneSentenceWithName:(NSString *)name hour:(NSNumber *)hour place:(NSString *)palce doSomething:(NSString *)doSomething;

@end
