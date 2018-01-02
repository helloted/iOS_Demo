//
//  NSData+HT.h
//  
//
//  Created by zhuzhi on 13-7-19.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MY)

- (NSString *)base64Encoded;
- (NSData *)base64Decoded;

- (NSData *)desEncodeDataWithKey:(NSString *)key;
- (NSData *)desDecodeDataWithKey:(NSString *)key;
- (NSData *)desEncodeData;
- (NSData *)desDecodeData;

- (NSData *)SHA256Hash;

@end
