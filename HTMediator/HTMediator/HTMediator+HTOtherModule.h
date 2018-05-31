//
//  HTMediator+HTOtherModule.h
//  HTMediator
//
//  Created by iMac on 2018/5/31.
//  Copyright © 2018年 HelloTed. All rights reserved.
//

#import "HTMediator.h"

@interface HTMediator (HTOtherModule)

- (NSString *)otherModulePerform:(NSString *)targetName action:(NSString *)actionName name:(NSString *)name hour:(NSUInteger)hour place:(NSString *)palce doSomething:(NSString *)doSomething;

@end
