//
//  HTURLGenerator.m
//  NetWorkDemo
//
//  Created by iMac on 2017/9/21.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "HTURLGenerator.h"

@implementation HTURLGenerator

-(NSString *)generateURLStringWithRoute:(HTRequsetRoute)route{
    NSMutableString *url = [NSMutableString stringWithString:ServerAddress];
    [url appendString:[self routeStringWithRoute:route]];
    return url;
}

- (NSString *)routeStringWithRoute:(HTRequsetRoute)route{
    NSString *str = @"";
    switch (route) {
        case HTRequsetRouteLogin:
            str = @"/user/login";
            break;
        case HTRequestRouteVoiceTest:
            str = @"/voice/normal";
            break;
            
        default:
            break;
    }
    return str;
}

@end
