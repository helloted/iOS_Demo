//
//  NSDictionary+ProtectNil.m
//  NilHandle
//
//  Created by Hao on 2019/1/18.
//  Copyright © 2019 Hao. All rights reserved.
//

#import "NSDictionary+ProtectNil.h"
#import <objc/runtime.h>

static inline void swizzling_method(Class _originalClass ,SEL _originalSel,Class _newClass ,SEL _newSel){
    Method methodOriginal = class_getInstanceMethod(_originalClass, _originalSel);
    Method methodNew = class_getInstanceMethod(_newClass, _newSel);
    
    IMP impNew = method_getImplementation(methodNew);
    IMP impOriginal = method_getImplementation(methodOriginal);
    
    bool didAddMethod = class_addMethod(_originalClass,_originalSel,impNew,method_getTypeEncoding(methodNew));
    if (didAddMethod) {
        class_replaceMethod(_originalClass,_newSel,impOriginal,method_getTypeEncoding(methodOriginal));
    }else{
        method_exchangeImplementations(methodOriginal, methodNew);
    }
}

@implementation NSDictionary (ProtectNil)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = object_getClass((id)self);
        swizzling_method(class, @selector(initWithObjects:forKeys:count:), class, @selector(weg_initWithObjects:forKeys:count:));
        swizzling_method(class, @selector(dictionaryWithObjects:forKeys:count:), class, @selector(weg_dictionaryWithObjects:forKeys:count:));
    });
}

+ (instancetype)weg_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self weg_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

+ (instancetype)na_dictionaryWithObjects:(const id [])objects forKeys:(const id <NSCopying> [])keys count:(NSUInteger)cnt {
    id nObjects[cnt];
    id nKeys[cnt];
    int i=0, j=0;
    for (; i<cnt && j<cnt; i++) {
        if (objects[i] && keys[i]) {
            nObjects[j] = objects[i];
            nKeys[j] = keys[i];
            j++;
        }
    }
    
    return [self na_dictionaryWithObjects:nObjects forKeys:nKeys count:j];
}


- (instancetype)weg_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self weg_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@implementation NSMutableDictionary (ProtectNil)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        swizzling_method(class, @selector(setObject:forKey:), class, @selector(weg_setObject:forKey:));
        swizzling_method(class, @selector(setObject:forKeyedSubscript:), class, @selector(weg_setObject:forKeyedSubscript:));
    });
}

- (void)weg_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey || !anObject) {
        return;
    }
    [self weg_setObject:anObject forKey:aKey];
}

- (void)weg_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key || !obj) {
        return;
    }
    [self weg_setObject:obj forKeyedSubscript:key];
}

@end
