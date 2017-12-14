//
//  Person.m
//  CopyDemo
//
//  Created by iMac on 2017/12/14.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "Person.h"

@implementation Person


- (id)copyWithZone:(NSZone *)zone{
    Person *copyPerson = [[Person allocWithZone:zone] init];
    copyPerson.age = _age;
    copyPerson.name = _name;
    return copyPerson;
}

@end
