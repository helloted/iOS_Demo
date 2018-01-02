//
//  UIDevice+HT.h
//  helloTalk
//
//  Created by 任健生 on 13-3-2.
//
//
#ifndef GCDExecOnce
#define GCDExecOnce(block) \
{ \
static dispatch_once_t predicate = 0; \
dispatch_once(&predicate, block); \
}
#endif


#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const UIStatusBarOrientationDidChangeNotification;

#define IOS8 [[UIDevice currentDevice] isIOS8]
#define IOS7 [[UIDevice currentDevice] isIOS7]
#define IOS6 [[UIDevice currentDevice] isIOS6]
#define iPad [[UIDevice currentDevice] isPad]

@interface UIDevice (MY)

- (NSString *)devicePlatform;
- (BOOL)isIOS6;
- (BOOL)isIOS7;
- (BOOL)isIOS8;


@end
