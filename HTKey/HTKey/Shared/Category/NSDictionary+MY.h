//
//  NSDictionary+HT.h
//  
//
//  Created by Horace on 13-6-18.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MY)

- (NSString *)stringForKey:(id)key;
- (BOOL)boolForKey:(id)key;
- (int)intForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (uint)uintForKey:(id)key;
- (double)doubleForKey:(id)key;
- (float)floatForKey:(id)key;
- (long long)longLongForKey:(id)key;
- (long)longForKey:(id)key;
- (u_int64_t)ulongLongForKey:(id)key;
- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;

- (NSString *)jsonString;

- (id)exitObjectForKey:(id)key;
- (id)exitObjectOrStringForKey:(id)key;

@end

@interface NSArray (MY)
- (NSString *)jsonString;
@end
