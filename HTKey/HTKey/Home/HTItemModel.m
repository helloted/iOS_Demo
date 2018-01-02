//
//  HTItemModel.m
//  HTKey
//
//  Created by iMac on 2018/1/2.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTItemModel.h"

@implementation HTItemModel

//解档
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ([super init]) {
//        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.avatar forKey:@"avatar"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeInteger:self.age forKey:@"age"];
}

@end
