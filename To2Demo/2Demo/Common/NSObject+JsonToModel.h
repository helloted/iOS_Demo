//
//  NSObject+JsonToModel.h
//  JsonToModel
//
//  Created by iMac on 2017/10/11.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonToModel)

+(instancetype)ht_modelFromJson:(id)json;

-(instancetype)modelWithJsonDictionary:(NSDictionary *)dict;

- (void)updateModelWithJson:(id)json;

@end

@protocol JSONModelSpecialAttributesProtocol <NSObject>

@optional

+ (NSDictionary *)attributesMapperDictionary;
+ (NSDictionary *)attributesNestDictionary;

@end
