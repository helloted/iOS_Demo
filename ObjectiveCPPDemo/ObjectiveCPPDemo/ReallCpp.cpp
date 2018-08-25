//
//  ReallCpp.cpp
//  ObjectiveCPPDemo
//
//  Created by Hao on 2018/8/8.
//  Copyright © 2018年 haozhicao. All rights reserved.
//

#include "ReallCpp.hpp"


ObjectCpp::ObjectCpp(){
    
}


void ObjectCpp::call_oc_function(void *ocObj, interface function, void *parameter){
    function(ocObj,parameter);
}

ObjectCpp::~ObjectCpp(){
    std::cout<< "CPP Object released"<< std::endl;
}
