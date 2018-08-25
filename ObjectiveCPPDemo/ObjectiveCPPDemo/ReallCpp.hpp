//
//  ReallCpp.hpp
//  ObjectiveCPPDemo
//
//  Created by Hao on 2018/8/8.
//  Copyright © 2018年 haozhicao. All rights reserved.
//

#ifndef ReallCpp_hpp
#define ReallCpp_hpp

#include <stdio.h>
#include "CppOCBridge.h"
#include <iostream>

class ObjectCpp {
public:
    ObjectCpp();
    ~ObjectCpp();
    void call_oc_function(void *ocObj, interface function, void* parameter);
};

#endif /* ReallCpp_hpp */
