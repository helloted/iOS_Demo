//
//  HTNetWorkEnum.h
//  NetWorkDemo
//
//  Created by iMac on 2017/9/20.
//  Copyright © 2017年 iMac. All rights reserved.
//

#ifndef HTNetWorkEnum_h
#define HTNetWorkEnum_h

typedef enum : NSUInteger {
    HTRequsetRouteLogin,
    HTRequsetRouteRegister,
    HTRequsetRouteLogout,
    HTRequestRoutePostFile,
    HTRequestRouteVoiceTest
} HTRequsetRoute;

typedef enum : NSUInteger {
    HTRequsetMethodNormalGET,    //普通GET请求
    HTRequsetMethodEncryptGET,   //加密GET请求
    HTRequsetMethodNormalPOST,   //普通POST请求
    HTRequsetMethodEncryptPOST,  //加密POST请求
} HTRequsetMethod;

#endif /* HTNetWorkEnum_h */
