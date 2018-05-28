//
//  NSObject+JsonToModel.m
//  JsonToModel
//
//  Created by iMac on 2017/10/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "NSObject+JsonToModel.h"
#import <objc/runtime.h>

typedef enum : NSUInteger {
    HTEncodingTypeUnknown    = 0, ///< unknown
    HTEncodingTypeBool       = 1, ///< bool
    HTEncodingTypeInt8       = 2, ///< char / BOOL
    HTEncodingTypeUInt8      = 3, ///< unsigned char
    HTEncodingTypeInt16      = 4, ///< short
    HTEncodingTypeUInt16     = 5, ///< unsigned short
    HTEncodingTypeInt32      = 6, ///< int
    HTEncodingTypeUInt32     = 7, ///< unsigned int
    HTEncodingTypeInt64      = 8, ///< long long
    HTEncodingTypeUInt64     = 9, ///< unsigned long long
    HTEncodingTypeFloat      = 10, ///< float
    HTEncodingTypeDouble     = 11, ///< double
    HTEncodingTypeLongDouble = 12, ///< long double
} HTEncodingType;

@implementation NSObject (JsonToModel)

+ (instancetype)ht_modelFromJson:(id)json{
    id model = [[self alloc] init];
    [model updateModelWithJson:json];
    return model;
}

- (void)updateModelWithJson:(id)json{
    NSDictionary *jsonDict = [self dictionaryWithJSON:json];
    [self modelWithJsonDictionary:jsonDict];
}

/**
  各种类型的Json转字典
*/
- (NSDictionary *)dictionaryWithJSON:(id)json
{
    if (!json) {
        return nil;
    }
    // 若是NSDictionary类型，直接返回
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    
    NSDictionary *dict = nil;
    NSData *jsonData = nil;
    
    // 如果是NSString，就先转化为NSData
    if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    
    // 如果时NSData类型，使用NSJSONSerialization
    if (jsonData && [jsonData isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"dictionaryWithJSON error:%@", error);
            return nil;
        }
        if (![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
    }
    
    return dict;
}


-(instancetype)modelWithJsonDictionary:(NSDictionary *)dict{
    //获取当前类中的所有属性
    unsigned int propertyCount;
    objc_property_t *allPropertys = class_copyPropertyList([self class], &propertyCount);
    
    // 某些属性需要重新映射===
    NSDictionary *mapperDict;
    if ([self conformsToProtocol:@protocol(JSONModelSpecialAttributesProtocol)] && [[self class] respondsToSelector:@selector(attributesMapperDictionary)]) {
        mapperDict = [[self class] attributesMapperDictionary];
    }
    
    // 模型嵌套
    NSDictionary *nestDict;
    if ([self conformsToProtocol:@protocol(JSONModelSpecialAttributesProtocol)] && [[self class] respondsToSelector:@selector(attributesNestDictionary)]) {
        nestDict = [[self class] attributesNestDictionary];
    }
    
    for (NSInteger i = 0; i < propertyCount; i ++) {
        objc_property_t property = allPropertys[i];
        
        //拿到属性名称和类型
        NSString *property_name = [NSString stringWithUTF8String:property_getName(property)];
        
        // 如果有属性需要重新映射===
        NSString *key = property_name;
        if (mapperDict && [mapperDict objectForKey:property_name]) {
            key = [mapperDict objectForKey:property_name];
        }
        
        // 从Json字典里获取值
        id value = [dict objectForKey:key];
        if (value == nil) {
            continue;
        }
        
        // 如果有属性嵌套其他Model
        if (nestDict && [nestDict objectForKey:property_name]) {
            NSString *className = [nestDict objectForKey:property_name];
            Class class = NSClassFromString(className);
            id obj = [[class alloc]init];
            [obj modelWithJsonDictionary:value];
            [self setValue:obj forKey:key];
        }else{
            [self setValue:value forKey:key];
        }
        
//        getProperyType(property);
    }
    
    free(allPropertys);
    return self;
}


HTEncodingType getProperyType(objc_property_t property){
    unsigned int count = 0;
    objc_property_attribute_t *attributes = property_copyAttributeList(property, &count);
    const char *encodingType = attributes[0].value;
    
    NSLog(@"name--%@",[NSString stringWithUTF8String:encodingType]);
    
    char *type = (char *)encodingType;
    if (!type) return HTEncodingTypeUnknown;
    size_t len = strlen(type);
    
    if (len == 1) { //数型
        switch (*type) {
            case 'B': return HTEncodingTypeBool;
            case 'c': return HTEncodingTypeInt8;
            case 'C': return HTEncodingTypeUInt8;
            case 's': return HTEncodingTypeInt16;
            case 'S': return HTEncodingTypeUInt16;
            case 'i': return HTEncodingTypeInt32;
            case 'I': return HTEncodingTypeUInt32;
            case 'l': return HTEncodingTypeInt32;
            case 'L': return HTEncodingTypeUInt32;
            case 'q': return HTEncodingTypeInt64;
            case 'Q': return HTEncodingTypeUInt64;
            case 'f': return HTEncodingTypeFloat;
            case 'd': return HTEncodingTypeDouble;
            case 'D': return HTEncodingTypeLongDouble;
            default: return HTEncodingTypeUnknown;
        }
    }else{
        return HTEncodingTypeUnknown;
    }
}


+(NSString *)getProperyType:(objc_property_t)property{
    //得到的是一个类似于T@"NSString",C,N,V_name 这样的一个字符串
    NSString *attributeStr = [NSString stringWithUTF8String:property_getAttributes(property)];
    
    //取出类型名
    NSArray  *array = [attributeStr componentsSeparatedByString:@","];
    NSString *typeStr = [array firstObject];
    
    if ([attributeStr containsString:@"T@\"NSString\""]){
        return @"NSString";
    }else if ([attributeStr containsString:@"T@\"NSNumber\""]){
        return @"NSNumber";
    }else if ([attributeStr containsString:@"Ti"]){
        return @"int";
    }else if ([attributeStr containsString:@"Tq"]){
        return @"NSInteger";
    }else if ([attributeStr containsString:@"TQ"]){
        return @"NSUInteger";
    }else if ([attributeStr containsString:@"Td"]){
        return @"double";
    }else if ([attributeStr containsString:@"Tf"]){
        return @"float";
    }else if ([attributeStr containsString:@"T^B"]){
        return @"BOOL";
    }
    return typeStr;
}

@end
