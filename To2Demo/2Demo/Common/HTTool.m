//
//  HTTool.m
//  2Demo
//
//  Created by iMac on 2018/5/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTTool.h"
#import <CommonCrypto/CommonCrypto.h>
//#import <objc/runtime.h>
//#include <netinet/in.h>
//#include <net/if.h>
//#include <net/if_dl.h>
//#import <sys/utsname.h>


@implementation HTTool

+ (NSString *)md5:(NSString *)src
{
    if (src && src.length > 0) {
        const char *cStr = [src UTF8String];
        unsigned char result[16];
        CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    return nil;
}

@end
