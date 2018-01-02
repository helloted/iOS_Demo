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
        _type = [aDecoder decodeObjectForKey:@"type"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _account = [aDecoder decodeObjectForKey:@"account"];
        _password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}


//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_type forKey:@"type"];
    [aCoder encodeObject:_account forKey:@"account"];
    [aCoder encodeObject:_password forKey:@"password"];
}

@end
