//
//  HTAuthenticaTool.m
//  HTKey
//
//  Created by iMac on 2018/1/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTAuthenticaTool.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation HTAuthenticaTool

+ (BOOL)supportAuthentication{
    LAContext *context = [LAContext new];
    //这个属性是设置指纹输入失败之后的弹出框的选项
    context.localizedFallbackTitle = @"没有忘记密码";
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)open{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AuthenticaToolOpen"];
}

+ (void)close{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AuthenticaToolOpen"];
}

+(void)startAuth{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AuthenticaToolOpen"]) {
        return;
    }
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = [UIScreen mainScreen].bounds;
    [UI_WINDOW addSubview:effectView];
    
    LAContext *context = [LAContext new];
    __block UIVisualEffectView *blockView = effectView;
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请按home键指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockView removeFromSuperview];
            });
        }else{
            NSLog(@"%@",error.localizedDescription);
            switch (error.code) {
                case LAErrorSystemCancel:
                {
                    NSLog(@"系统取消授权，如其他APP切入");
                    break;
                }
                case LAErrorUserCancel:
                {
                    NSLog(@"用户取消验证Touch ID");
                    break;
                }
                case LAErrorAuthenticationFailed:
                {
                    NSLog(@"授权失败");
                    break;
                }
                case LAErrorPasscodeNotSet:
                {
                    NSLog(@"系统未设置密码");
                    break;
                }
                case LAErrorTouchIDNotAvailable:
                {
                    NSLog(@"设备Touch ID不可用，例如未打开");
                    break;
                }
                case LAErrorTouchIDNotEnrolled:
                {
                    NSLog(@"设备Touch ID不可用，用户未录入");
                    break;
                }
                case LAErrorUserFallback:
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSLog(@"用户选择输入密码，切换主线程处理");
                    }];
                    break;
                }
                default:
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSLog(@"其他情况，切换主线程处理");
                    }];
                    break;
                }
            }
        }
    }];
    
}

@end
