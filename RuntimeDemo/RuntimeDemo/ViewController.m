//
//  ViewController.m
//  RuntimeDemo
//
//  Created by Devond on 16/5/24.
//  Copyright © 2016年 Devond. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define SelfClass [self class]

@interface ViewController ()
@property (nonatomic, strong) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 调用方法方案1
    //    objc_msgSend(self,@selector(initial:),@"完成初始化");
    // 调用方法方案2
    Method method = [self class_getInstanceMethod:SelfClass selector:@selector(initial:)];
    [self method_invoke:self method:method];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize
- (void)initial:(NSString *)str{
    if (str) NSLog(@"%@",str);
    _person = [[Person alloc] init];
    _person.name = @"xietao";
    _person.age = @"18";
    _person.gender = @"male";
    _person.city = @"shanghai";
    
    [self logRunTimeAction:nil];
}

#pragma mark - IBAction
- (IBAction)logRunTimeAction:(id)sender {
    objc_property_attribute_t attrs[] = { { "T", "@\"NSString\"" }, { "&", "N" }, { "V", "" } };
    
    size_t objSize = class_getInstanceSize([_person class]);
    size_t allocSize = 2 * objSize;
    uintptr_t ptr = (uintptr_t)calloc(allocSize, 1);
    
    
    // Class
    [self class_getClassName:SelfClass];
    [self class_getSuperClass:SelfClass];
    [self class_getInstanceSize:SelfClass];
    [self class_getInstanceVariable:SelfClass name:"_person"];
    [self class_getClassVariable:SelfClass name:"Person"];
    [self class_getInstanceMethod:SelfClass selector:@selector(class_getInstanceMethod:selector:)];
    [self.class class_getClassMethod:SelfClass selector:@selector(class_getClassMethod:selector:)];
    [self class_getProperty:SelfClass name:"person"];
    [self class_getMethodImplementation:SelfClass selector:@selector(class_getMethodImplementation:selector:)];
    [self class_getMethodImplementation_stret:SelfClass selector:@selector(class_getMethodImplementation_stret:selector:)];
    [self class_copyIvarList:[_person class]];
    [self class_copyPropertyList:[_person class]];
    [self class_copyMethodList:[_person class]];
    [self class_copyProtocolList:[_person class]];
    [self class_addIvar:[_person class] name:"country" size:sizeof(NSString *) alignment:0 types:"@"]; // 无效方法
    [self class_addProperty:[_person class] name:"country" attributes:nil attributeCount:3];
    [self class_addMethod:SelfClass selector:NSSelectorFromString(@"runtimeTestMethod:") imp:nil types:"v@:@"];
    [self class_addProtocol:[_person class] protocol:@protocol(RuntimeBaseProtocol)];
    [self class_replaceProperty:[_person class] name:"country" attributes:nil attributeCount:3];
    [self class_replaceMethod:[_person class] selector:@selector(runtimeTestAction1) imp:class_getMethodImplementation([_person class], @selector(runtimeTestAction2)) types:"v@:"];
    [self class_respondsToSelector:[_person class] selector:@selector(runtimeTestAction1)];
    [self class_isMetaClass:object_getClass(self.superclass)];
    [self class_conformsToProtocol:[_person class] protocol:NSProtocolFromString(@"RuntimeBaseProtocol")];
    [self class_createInstance:[_person class] extraBytes:class_getInstanceSize([_person class])];
    
    // Object
    [self object_getInstanceVariable:_person name:"_name" outValue:nil];
    [self object_getClassName:_person];
    [self object_getClass:_person];
    [self objc_getClass:"Person"];
    [self objc_getMetaClass:"Person"];
    [self objc_getProtocol:"RuntimeBaseProtocol"];
    [self object_copy:_person size:class_getInstanceSize([_person class])];
    //    [self objc_copyProtocolList];//打印大量数据
    //    [self objc_copyClassList];// 打印大量信息
    [self object_setInstanceVariable:_person name:"_name" value:@"newName"];
    [self object_setIvar:_person ivar:object_getInstanceVariable(_person, "_name", nil) value:@"NEWNAME"];
    [self objc_setAssociatedObject:_person key:"_title" value:@"dev" policy:OBJC_ASSOCIATION_RETAIN];
    [self object_dispose:nil];
    [self objc_constructInstance:[_person class] bytes:(void *)ptr];
    [self objc_destructInstance:nil];
    
    Class class = [self objc_allocateClassPair:[_person class] name:"student" size:0];
    [self objc_registerClassPair:class];
    [self objc_disposeClassPair:class];
    
    Protocol *protocol = [self objc_allocateProtocol:"NewProtocol"];
    [self objc_registerProtocol:protocol];
    [self class_addProtocol:[_person class] protocol:NSProtocolFromString(@"NewProtocol")];
    [self class_copyProtocolList:[_person class]];
    
    // Method
    Method method = [self class_getInstanceMethod:SelfClass selector:@selector(initial:)];
    [self method_getName:method];
    [self method_getImplementation:method]; // 该方法imp_implementationWithBlock使得imp几乎相当于block
    [self method_getTypeEncoding:method];
    [self method_getArgumentType:method];
    [self method_copyReturnType:method];
    [self method_copyArgumentType:method];
    [self method_getReturnType:method];
    [self method_setImplementation:class_getInstanceMethod(SelfClass, @selector(method_setImplementation:))];
    [self method_exchangeImplementations:class_getInstanceMethod([_person class], @selector(runtimeTestAction3)) method:class_getInstanceMethod([_person class], @selector(runtimeTestAction2))];
    [self method_getDescription:method];
    
    // Sel
    [self sel_getName:@selector(sel_getName:)];
    [self sel_registerName:"runtimeTestAction3"];
    [self sel_getUid:"runtimeTestAction3"];
    [self sel_isEqual:@selector(runtimeTestAction3) sel2:@selector(runtimeTestAction2)];
    
    // Protocol
    [self protocol_getName:protocol];
    [self protocol_getProperty:NSProtocolFromString(@"RuntimeBaseProtocol") name:"protocolString" isRequiredProperty:YES isInstanceProperty:YES];
    
    Protocol *testProtocol = [self objc_allocateProtocol:"TestProtocol"];
    [self protocol_addProperty:testProtocol name:"newProperty" attributes:attrs attributeCount:3 isRequiredProperty:YES isInstanceProperty:YES];
    [self protocol_addProtocol:testProtocol addition:protocol];
    [self protocol_addMethodDescription:testProtocol sel:@selector(runtimeTestAction3) types:"v@:" isRequiredMethod:NO isInstanceMethod:YES]; // 已注册的协议无法添加
    
    [self objc_registerProtocol:testProtocol];
    
    [self protocol_copyPropertyList:testProtocol];
    [self protocol_copyProtocolList:testProtocol];
    [self protocol_copyMethodDescriptionList:testProtocol isRequiredMethod:NO isInstanceMethod:YES];
    [self protocol_isEqual:testProtocol other:protocol];
    [self protocol_conformsToProtocol:testProtocol other:protocol];
    
    
}


#pragma mark - Class 创建
- (void)class_createInstance:(Class)class extraBytes:(size_t)extraBytes {
    Person *tempPerson = class_createInstance(class, extraBytes);
    tempPerson.name = @"instance creat Success";
    NSLog(@"%s%@",__func__,tempPerson.name);
}

#pragma mark - Class 类名，父类，元类；实例变量，成员变量；属性；实例方法，类方法，方法实现；
/**
 *  获取类的类名
 *
 *  @param class 类
 */
- (void)class_getClassName:(Class)class {
    NSLog(@"%s:%s",__func__,class_getName(class));
}

/**
 *  获取类的父类
 *
 *  @param class 类
 */
- (void)class_getSuperClass:(Class)class {
    NSLog(@"%s%@",__func__,NSStringFromClass(class_getSuperclass(class)));
}

/**
 *  获取实例大小
 *
 *  @param class 类
 */
- (void)class_getInstanceSize:(Class)class {
    NSLog(@"%s%zu",__func__,class_getInstanceSize(class));
}

/**
 *  获取类中指定名称实例成员变量的信息
 *
 *  @param class 类
 *  @param name  成员变量名
 */
- (void)class_getInstanceVariable:(Class)class name:(const char *)name {
    Ivar ivar = class_getInstanceVariable(class,name);
    NSLog(@"%s%s%s",__func__,[self ivar_getTypeEncoding:ivar],[self ivar_getName:ivar]);
}

/**
 *  获取类成员变量的信息（该函数没有作用，官方解释:http://lists.apple.com/archives/objc-language/2008/Feb/msg00021.html
 *
 *  @param class 类
 *  @param name  成员变量名
 */
- (void)class_getClassVariable:(Class)class name:(const char *)name {
    Ivar ivar = class_getClassVariable(class,name);
    NSLog(@"%s%s%s",__func__,[self ivar_getTypeEncoding:ivar],[self ivar_getName:ivar]);
}

/**
 *  获取属性的信息(与获取成员变量信息类似，不同的是不用打_)
 *
 *  @param class 类
 *  @param name  属性名
 */
- (void)class_getProperty:(Class)class name:(const char *)name {
    objc_property_t property = class_getProperty(class,name);
    NSLog(@"%s%s%s",__func__,[self property_getName:property] ,[self property_getAttributes:property]);
    [self property_copyAttributeList:property];
}

/**
 *  获取类制定方法的信息
 *
 *  @param class    类
 *  @param selector 方法
 */
- (Method)class_getInstanceMethod:(Class)class selector:(SEL)selector {
    Method method = class_getInstanceMethod(class, selector);
    NSLog(@"%s%s%u",__func__,sel_getName(method_getName(method)) ,[self method_getNumberOfArguments:method]);
    return method;
}

/**
 *  获取类方法的信息
 *
 *  @param class    类
 *  @param selector 方法
 */
+ (Method)class_getClassMethod:(Class)class selector:(SEL)selector {
    Method method = class_getClassMethod(class, selector);
    NSLog(@"%s%s%u",__func__,sel_getName(method_getName(method)) ,method_getNumberOfArguments(method));
    return method;
}

/**
 *  获取方法具体实现
 *
 *  @param class    类
 *  @param selector 方法
 *
 *  @return IMP
 */
- (IMP)class_getMethodImplementation:(Class)class selector:(SEL)selector {
    IMP imp = class_getMethodImplementation(class, selector);
    return imp;
}

/**
 *  获取类中的方法的实现,该方法的返回值类型为struct
 *
 *  @param class    类
 *  @param selector 方法
 *
 *  @return IMP
 */
- (IMP)class_getMethodImplementation_stret:(Class)class selector:(SEL)selector {
    IMP imp = class_getMethodImplementation_stret(class, selector);
    return imp;
}

#pragma mark - Class 成员变量列表；属性列表；方法列表；协议列表；
/**
 *  获取成员变量列表
 *
 *  @param class 类
 */
- (void)class_copyIvarList:(Class)class {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList(class, &count);
    NSLog(@"%s",__func__);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        // 获取成员属性名
        NSString *name = [NSString stringWithUTF8String:[self ivar_getName:ivar]];
        NSString *type = [NSString stringWithUTF8String:[self ivar_getTypeEncoding:ivar]];
        //        NSString *value = object_getIvar(obj, ivar);
        NSLog(@"%@%@",type,name);
    }
}

- (void)class_copyPropertyList:(Class)class {
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList(class,&count);
    NSLog(@"%s",__func__);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        // 获取成员属性名
        NSString *name = [NSString stringWithUTF8String:[self property_getName:property]];
        NSString *type = [NSString stringWithUTF8String:[self property_getAttributes:property]];
        NSLog(@"%@%@",type,name);
    }
}

/**
 *  获取方法列表
 *
 *  @param class 类
 */
- (void)class_copyMethodList:(Class)class {
    unsigned int count;
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"%s%s",__func__,sel_getName(method_getName(method)));
    }
}

/**
 *  获取协议列表
 *
 *  @param class 类
 */
- (void)class_copyProtocolList:(Class)class {
    unsigned int count;
    Protocol **protocolList = class_copyProtocolList(class,&count);
    for (int i = 0; i < count; i++) {
        Protocol *protocol = protocolList[i];
        NSLog(@"%s%s",__func__,[self protocol_getName:protocol]);
    }
}

#pragma mark - Class add: 成员变量；属性；方法；协议
/**
 *  添加成员变量(添加成员变量只能在运行时创建的类，且不能为元类)
 *
 *  @param class     类
 *  @param name      成员变量名字
 *  @param size      大小
 *  @param alignment 对其方式
 *  @param types     参数类型
 */
- (void)class_addIvar:(Class)class name:(const char *)name size:(size_t)size alignment:(uint8_t)alignment types:(const char *)types {
    
    //    if (class_addIvar([_person class], "country", sizeof(NSString *), 0, "@")) {
    if (class_addIvar(class, name, size, alignment, types)) {
        
        NSLog(@"%sadd ivar success",__func__);
    }else{
        NSLog(@"%sadd ivar fail",__func__);
    }
}

/**
 *  添加属性
 *
 *  @param class          类
 *  @param name           属性名
 *  @param attributes     参数
 *  @param attributeCount 参数数量
 */
- (void)class_addProperty:(Class)class name:(const char *)name attributes:(const objc_property_attribute_t *)attributes attributeCount:(unsigned int)attributeCount {
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "&", "N" }; // C = copy
    objc_property_attribute_t backingivar  = { "V", "" };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    
    if (class_addProperty(class, name, attrs, attributeCount)) {
        NSLog(@"%sadd Property success",__func__);
    }else{
        NSLog(@"%sadd Property fail",__func__);
    }
    //    [self class_copyPropertyList:class];
}

/**
 *  添加方法
 *
 *  @param class    类
 *  @param selector 方法
 *  @param imp      方法实现
 *  @param types    类型
 */
- (void)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types {
    if (class_addMethod(class,selector,class_getMethodImplementation(class, selector),types)) {
        NSLog(@"%sadd method success",__func__);
    }else{
        NSLog(@"%sadd method fail",__func__);
    }
    //    [self class_copyMethodList:class];
    
}

/**
 *  添加协议
 *
 *  @param class    类
 *  @param protocol 协议
 */
- (void)class_addProtocol:(Class)class protocol:(Protocol *)protocol {
    if (class_addProtocol(class, protocol)) {
        NSLog(@"%sadd protocol success",__func__);
    }else{
        NSLog(@"%sadd protocol fail",__func__);
    }
    //    [self class_copyProtocolList:class];
}


#pragma marl - Class replace：属性；方法
/**
 *  替换属性的信息(如果没有原属性会新建一个属性)
 *
 *  @param class          类
 *  @param name           属性名
 *  @param attributes     类型
 *  @param attributeCount 类型数量
 */
- (void)class_replaceProperty:(Class)class name:(const char *)name attributes:(const objc_property_attribute_t *)attributes attributeCount:(unsigned int)attributeCount {
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "C", "" }; // C = copy
    objc_property_attribute_t backingivar  = { "V", "" };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    
    class_replaceProperty(class, name, attrs, 3);
    //    [self class_copyPropertyList:class];
    
}

/**
 *  替代方法的实现
 *
 *  @param class    类
 *  @param selector 被替代的方法
 *  @param imp      替代方法
 *  @param types    类型
 */
- (void)class_replaceMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types {
    class_replaceMethod(class, selector, imp, types);
    NSLog(@"%s",__func__);
    [_person runtimeTestAction1];
}

#pragma mark - Class 判断
/**
 *  查看类是否相应指定方法
 *
 *  @param class    类
 *  @param selector 方法
 */
- (void)class_respondsToSelector:(Class)class selector:(SEL)selector {
    if (class_respondsToSelector(class,selector)) {
        NSLog(@"%s %@ exist",__func__,NSStringFromClass(class));
    }else{
        NSLog(@"%s %@ non-exist",__func__,NSStringFromClass(class));
    }
}

/**
 *  查看类是否为元类
 *
 *  @param class 类
 */
- (void)class_isMetaClass:(Class)class {
    if (class_isMetaClass(class)) {
        NSLog(@"%s %@ isMetaClass",__func__,NSStringFromClass(class));
    }else{
        NSLog(@"%s %@ non-isMetaClass",__func__,NSStringFromClass(class));
    }
}

/**
 *  查看类是否遵循指定协议
 *
 *  @param class    类
 *  @param protocol 协议
 */
- (BOOL)class_conformsToProtocol:(Class)class protocol:(Protocol *)protocol {
    if (class_conformsToProtocol(class, protocol)) {
        NSLog(@"%s %@ conformsToProtocol %@",__func__,NSStringFromClass(class),NSStringFromProtocol(protocol));
        return YES;
    }else{
        NSLog(@"%s %@ non-conformsToProtocol %@",__func__,NSStringFromClass(class),NSStringFromProtocol(protocol));
        return NO;
    }
}


#pragma mark - Objc get: 实例变量；成员变量；类名；类；元类；关联对象；协议；协议列表
/**
 *  获取实例的成员变量
 *
 *  @param obj      对象
 *  @param name     成员变量名
 *  @param outValue 输出值
 */
- (void)object_getInstanceVariable:(id)obj name:(const char*)name outValue:(void **)outValue{
    Ivar ivar = object_getInstanceVariable(obj, name, nil);
    NSLog(@"%s personName %@",__func__,[self object_getIvar:obj ivar:ivar]);
}

/**
 *  获取成员变量的值
 *
 *  @param obj  对象
 *  @param ivar 成员变量
 *
 *  @return 值
 */
- (id)object_getIvar:(id)obj ivar:(Ivar)ivar {
    return object_getIvar(obj, ivar);
}

/**
 *  获取指定对象的类名
 *
 *  @param obj 对象
 */
- (void)object_getClassName:(id)obj {
    NSLog(@"%s%s",__func__,object_getClassName(obj));
}

/**
 *  获取指定对象的类
 *
 *  @param obj 对象
 */
- (void)object_getClass:(id)obj {
    NSLog(@"%s%@",__func__,NSStringFromClass(object_getClass(obj)));
}

/**
 *  拷贝指定对象
 *
 *  @param obj  对象
 *  @param size 实例大小
 */
- (void)object_copy:(id)obj size:(size_t)size {
    Person *tempObj = object_copy(obj, size);
    tempObj.name = @"tempxietao";
    NSLog(@"%s tempPersonName:%@ personName:%@",__func__,tempObj.name,_person.name);
}

/**
 *  获取指定类名的类
 *
 *  @param name 类名
 */
- (void)objc_getClass:(const char *)name {
    NSLog(@"%s%@",__func__,NSStringFromClass(objc_getClass(name)));
}

/**
 *  获取指定类的元类
 *
 *  @param name 类名
 */
- (void)objc_getMetaClass:(const char *)name {
    NSLog(@"%s%@",__func__,NSStringFromClass(objc_getMetaClass(name)));
    
}

/**
 *  获取指定名字的协议
 *
 *  @param name 协议名称
 */
- (void)objc_getProtocol:(const char *)name {
    Protocol *protocol = objc_getProtocol("RuntimeBaseProtocol");
    NSLog(@"%s %s",__func__,[self protocol_getName:protocol]);
    //    [self class_conformsToProtocol:[_person class] protocol:protocol];
}

/**
 *  获取关联对象的值
 *
 *  @param obj 关联对象
 *  @param key 关联Key
 */
- (void)objc_getAssociatedObject:(id)obj key:(const void *)key {
    id object = objc_getAssociatedObject(obj,key);
    NSLog(@"%s %s %s %@",__func__,object_getClassName(obj),key,object);
}

/**
 *  获取所有已注册类信息
 */
- (void)objc_copyClassList{
    unsigned int count = 0;
    
    Class *classes = objc_copyClassList(&count);
    
    for (unsigned int i = 0; i < count; i++) {
        Class class = classes[i];
        NSLog(@"%s%s",__func__,class_getName(class));
    }
}

/**
 *  获取运行时所知道的所有协议的数组(打印大量数据)
 */
- (void)objc_copyProtocolList {
    unsigned int count = 0;
    Protocol **protocolList = objc_copyProtocolList(&count);
    for (int i = 0; i < count; i++) {
        Protocol *protocol = protocolList[i];
        NSLog(@"%s%s",__func__,[self protocol_getName:protocol]);
    }
    
}

#pragma mark - Objc set: 实例变量；成员变量；协议
/**
 *  设置指定实例指定名称的成员变量的值
 *
 *  @param obj   对象
 *  @param name  成员变量名
 *  @param value 值
 */
- (void)object_setInstanceVariable:(id)obj name:(const char *)name value:(void *)value {
    Ivar ivar = object_setInstanceVariable(obj,name,value);
    NSLog(@"%s %s %@",__func__,[self ivar_getName:ivar],object_getIvar(obj, ivar));
}


/**
 *  设置指定对象的指定的成员变量的值
 *
 *  @param obj   对象
 *  @param ivar  成员变量
 *  @param value 值
 */
- (void)object_setIvar:(id)obj ivar:(Ivar)ivar value:(void *)value {
    object_setIvar(obj,ivar,value);
    NSLog(@"%s %s %@ ",__func__,[self ivar_getName:ivar],object_getIvar(obj, ivar));
}

/**
 *  设置关联对象的值
 *
 *  @param obj    对象
 *  @param key    关联Key
 *  @param value  值
 *  @param policy 对象引用方式
 */
- (void)objc_setAssociatedObject:(id)obj key:(const void*)key value:(id)value policy:(objc_AssociationPolicy)policy{
    objc_setAssociatedObject(obj, key, value, policy);
    [self objc_getAssociatedObject:obj key:key];
}

#pragma mark - Objc 动态创建/销毁类、对象、协议
- (void)object_dispose:(id)objc {
    Person *tempPerson = [[Person alloc] init];
    tempPerson.name = @"tempName";
    object_dispose(tempPerson);
    // 释放后 无法取得name的值
    //    NSLog(@"%s release result %@",__func__,tempPerson.name);//会崩溃
}

/**
 *  在指定位置创建类实例
 *
 *  @param class 类名
 *  @param bytes 位置
 */
- (void)objc_constructInstance:(Class)class bytes:(void *)bytes {
    Person *obj = objc_constructInstance(class,bytes);
    obj.name = @"objc_constructInstance_name";
    NSLog(@"%s %@",__func__,obj.name);
}

/**
 *  销毁类实例
 *
 *  @param obj 销毁对象
 */
- (void)objc_destructInstance:(id)obj {
    Person *tempPerson = [[Person alloc] init];
    tempPerson.name = @"tempName";
    // 释放后 无法取得name的值
    objc_destructInstance(tempPerson);
    NSLog(@"%s destruct result %@",__func__,tempPerson.name);
}

/**
 *  创建一个新类和元类
 *
 *  @param superclass 父类
 *  @param name       类名
 *  @param size       额外大小 一般给0就好了
 */
- (Class)objc_allocateClassPair:(Class)superclass name:(const char*)name size:(size_t)size {
    Class newClass = objc_allocateClassPair(superclass,name,size);
    NSLog(@"%s creat new class named %@",__func__,NSStringFromClass(newClass));
    return newClass;
}

/**
 *  销毁一个类及其相关联的类
 *
 *  @param class 类名
 */
- (void)objc_disposeClassPair:(Class)class {
    objc_disposeClassPair(class);
    NSLog(@"%s disposs class named %@",__func__,NSStringFromClass(class));
    
}

/**
 *  在应用中注册由objc_allocateClassPair创建的类
 *
 *  @param class 类名
 */
- (void)objc_registerClassPair:(Class)class {
    objc_registerClassPair(class);
    NSLog(@"%s register class named %@",__func__,NSStringFromClass(class));
}

/**
 *  创建新的协议实例
 *
 *  @param name 协议名称
 *
 *  @return 协议实例
 */
- (Protocol *)objc_allocateProtocol:(const char *)name {
    // 检查该协议是否已经注册
    if (![self class_conformsToProtocol:SelfClass protocol:NSProtocolFromString([NSString stringWithUTF8String:name])]) {
        Protocol *protocol = objc_allocateProtocol(name);
        NSLog(@"%s creat protocol named %@",__func__,NSProtocolFromString([NSString stringWithUTF8String:name]));
        return protocol;
    }
    return nil;
}

/**
 *  在运行时中注册新创建的协议
 *
 *  @param protocol 协议
 */
- (void)objc_registerProtocol:(Protocol *)protocol {
    // 检查该协议是否已经注册
    if (protocol) {
        objc_registerProtocol(protocol);
        NSLog(@"%s register protocol named %s",__func__,[self protocol_getName:protocol]);
    }
    
}

/**
 *  移除该对象所有关联的的对象
 *
 *  @param object 对象
 */
- (void)objc_removeAssociatedObjects:(id)object {
    objc_removeAssociatedObjects(object);
}

#pragma mark - Ivar get
/**
 *  获取成员变量名
 *
 *  @param ivar 成员变量
 *
 *  @return 变量名
 */
- (const char *)ivar_getName:(Ivar)ivar {
    return ivar_getName(ivar);
}

/**
 *  获取成员变量类型编码
 *
 *  @param ivar 成员变量
 *
 *  @return 编码类型
 */
- (const char *)ivar_getTypeEncoding:(Ivar)ivar {
    return ivar_getTypeEncoding(ivar);
}

/**
 *  获取成员变量的偏移量
 *
 *  @param ivar 成员变量
 *
 *  @return 偏移量
 */
- (ptrdiff_t)ivar_getOffset:(Ivar)ivar {
    return ivar_getOffset(ivar);
}

#pragma mark - Property get
/**
 *  获取属性名
 *
 *  @param property 属性
 *
 *  @return 属性名
 */
- (const char *)property_getName:(objc_property_t)property {
    return property_getName(property);
}

/**
 *  获取属性特性描述字符串
 *
 *  @param property 属性
 *
 *  @return 属性特性字符串
 */
- (const char *)property_getAttributes:(objc_property_t)property {
    return property_getAttributes(property);
}

/**
 *  获取属性的特性列表
 *
 *  @param property 属性
 *
 *  @return 特性列表
 */
- (objc_property_attribute_t *)property_copyAttributeList:(objc_property_t)property {
    unsigned int outCount;
    objc_property_attribute_t *objc_property_attributes = property_copyAttributeList(property,&outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_attribute_t objc_property_attribute = objc_property_attributes[i];
        NSLog(@"%s %s %s",__func__,objc_property_attribute.name,[self property_copyAttributeValue:property attributeName:objc_property_attribute.name]);
    }
    return objc_property_attributes;
}

/**
 *  获取属性中指定的特性
 *
 *  @param property      属性
 *  @param attributeName 特性名
 *
 *  @return 特性
 */
- (const char *)property_copyAttributeValue:(objc_property_t)property attributeName:(const char *)attributeName {
    return property_copyAttributeValue(property,attributeName);
}

#pragma mark - Method invoke: 方法实现的返回值
/**
 *  调用指定方法的实现
 *
 *  @param receiver 被调用的对象
 *  @param method   被调用的方法
 */
- (void)method_invoke:(id)receiver method:(Method)method {
//    method_invoke(receiver,method);
}

#pragma mark - Method get: 方法名；方法实现；参数与返回值相关
/**
 *  获取方法名
 *
 *  @param method 方法
 *
 *  @return 方法选择器
 */
- (SEL)method_getName:(Method)method {
    SEL sel = method_getName(method);
    NSLog(@"%s %@",__func__,NSStringFromSelector(sel));
    return sel;
}

/**
 *  返回方法的实现
 *
 *  @param method 方法
 *
 *  @return 方法的实现
 */
- (IMP)method_getImplementation:(Method)method {
    IMP imp = method_getImplementation(method);
    return imp;
}

/**
 *  获取描述方法参数和返回值类型的字符串
 *
 *  @param method 方法
 *
 *  @return 方法的类型字符串
 */
- (const char *)method_getTypeEncoding:(Method)method {
    const char *methodType = method_getTypeEncoding(method);
    NSLog(@"%s %s",__func__,methodType);
    return methodType;
}

/**
 *  返回方法的参数的个数
 *
 *  @param method 方法
 *
 *  @return 方法参数的个数
 */
- (unsigned int)method_getNumberOfArguments:(Method)method {
    unsigned int num  = method_getNumberOfArguments(method);
    // 估计参数数量多出来的2个是调用的对象和selector
    NSLog(@"%s %@ has %d Arguments",__func__,NSStringFromSelector(method_getName(method)),num);
    return num;
}

#pragma mark - Method copy: 返回值类型，参数类型
/**
 *  获取指定位置参数的类型字符串
 *
 *  @param method 方法
 */
- (void)method_getArgumentType:(Method)method {
    unsigned int argumentsCount = [self method_getNumberOfArguments:method];
    char argName[512] = {};
    for (unsigned int j = 0; j < argumentsCount; ++j) {
        method_getArgumentType(method, j, argName, 512);
        
        NSLog(@"%@ 第%u个参数类型为：%s",NSStringFromSelector(method_getName(method)), j, argName);
        memset(argName, '\0', strlen(argName));
    }
}

/**
 *  获取方法的指定位置参数的类型字符串
 *
 *  @param method 方法
 */
- (void)method_copyArgumentType:(Method)method {
    unsigned int argumentsCount = [self method_getNumberOfArguments:method];
    for (int i = 0; i < argumentsCount; i++) {
        NSLog(@"%s 第%d个 argument type %s",__func__,i,method_copyArgumentType(method,i));
    }
}

/**
 *  获取方法的返回值类型的字符串
 *
 *  @param method 方法
 *
 *  @return 返回值类型字符串
 */
- (char *)method_copyReturnType:(Method)method {
    char *returnType = method_copyReturnType(method);
    NSLog(@"%s return type %s",__func__,returnType);
    return returnType;
}

/**
 *  通过引用返回方法的返回值类型字符串
 *
 *  @param method 方法
 */
- (void)method_getReturnType:(Method)method {
    char argNameType[512] = {};
    method_getReturnType(method,argNameType,512);
    NSLog(@"%s return type %s",__func__,argNameType);
    
}



#pragma mark - Method set: 方法实现 交换方法实现
/**
 *  设置方法的实现
 *
 *  @param method 方法
 */
- (void)method_setImplementation:(Method)method {
    IMP imp = imp_implementationWithBlock(^{
        NSLog(@"%s action",__func__);
    });
    method_setImplementation(method,imp);
}

/**
 *  交换两个方法的实现
 *
 *  @param method1 方法1
 *  @param method2 方法2
 */
- (void)method_exchangeImplementations:(Method)method1 method:(Method)method2 {
    method_exchangeImplementations(method1,method2);
    [_person runtimeTestAction2];
    [_person runtimeTestAction3];
}


#pragma mark - Method 方法描述
- (struct objc_method_description *)method_getDescription:(Method)method {
    struct objc_method_description *description = method_getDescription(method);
    NSLog(@"%s %@",__func__,NSStringFromSelector(description->name));
    return description;
}

#pragma mark - SEL
/**
 *  返回指定选择器指定的方法的名称
 *
 *  @param sel 方法选择器
 *
 *  @return 方法选择器名称
 */
- (const char *)sel_getName:(SEL)sel {
    const char *selName = sel_getName(sel);
    NSLog(@"%s %s",__func__,selName);
    return selName;
}

/**
 *  在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
 *
 *  @param name 方法名
 *
 *  @return 方法选择器
 */
- (SEL)sel_registerName:(const char *)name {
    SEL sel = sel_registerName(name);
    [_person performSelector:sel withObject:nil afterDelay:0];
    return sel;
}

/**
 *  在Objective-C Runtime系统中注册一个方法
 *
 *  @param name 方法名
 *
 *  @return 方法选择器
 */
- (SEL)sel_getUid:(const char *)name {
    SEL sel = sel_getUid(name);
    [_person performSelector:sel withObject:nil afterDelay:0];
    return sel;
    
}

/**
 *  比较两个选择器
 *
 *  @param sel1 方法选择器1
 *  @param sel2 方法选择器2
 *
 *  @return 是否匹配
 */
- (BOOL)sel_isEqual:(SEL)sel1 sel2:(SEL)sel2 {
    BOOL isEqual = sel_isEqual(sel1, sel2);
    if (isEqual) {
        NSLog(@"%s equal",__func__);
    }else{
        NSLog(@"%s unequal",__func__);
    }
    return isEqual;
}



#pragma mark - Protocol get: 协议；属性；
/**
 *  返回协议名
 *
 *  @param protocol 协议
 *
 *  @return 协议名
 */
- (const char *)protocol_getName:(Protocol *)protocol {
    const char *name = protocol_getName(protocol);
    //    NSLog(@"%s %s",__func__,name);
    return name;
}

/**
 *  获取协议的指定属性
 *
 *  @param protocol           协议
 *  @param name               属性名
 *  @param isRequiredProperty 是否为必须属性
 *  @param isInstanceProperty 是否为实例属性
 *
 *  @return 属性
 */
- (objc_property_t)protocol_getProperty:(Protocol *)protocol name:(const char *)name isRequiredProperty:(BOOL)isRequiredProperty isInstanceProperty:(BOOL)isInstanceProperty{
    objc_property_t property = protocol_getProperty(protocol, name, isRequiredProperty, isInstanceProperty);
    NSLog(@"%s %s",__func__,property_getName(property));
    return property;
}

#pragma mark - Protocol add：属性；方法；协议；
/**
 *  为协议添加属性（只能向未注册的协议中添加）
 *
 *  @param protocol           协议
 *  @param name               属性名
 *  @param attributes         属性类型字符串
 *  @param attributeCount     属性类型数量
 *  @param isRequiredProperty 是否为必需属性
 *  @param isInstanceProperty 是否为实例属性
 */
- (void)protocol_addProperty:(Protocol *)protocol name:(const char *)name attributes:(const objc_property_attribute_t *)attributes attributeCount:(unsigned int)attributeCount isRequiredProperty:(BOOL)isRequiredProperty isInstanceProperty:(BOOL)isInstanceProperty {
    protocol_addProperty(protocol, name, attributes, attributeCount, isRequiredProperty, isInstanceProperty);
}
/**
 *  为协议添加方法（只能向未注册的协议中添加）
 *
 *  @param protocol         协议
 *  @param sel              方法选择器
 *  @param types            方法类型
 *  @param isRequiredMethod 是否为必需方法
 *  @param isInstanceMethod 是否为实例方法
 */
- (void)protocol_addMethodDescription:(Protocol *)protocol sel:(SEL)sel types:(const char *)types isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod{
    protocol_addMethodDescription(protocol, sel, types, isRequiredMethod, isInstanceMethod);
}

/**
 *  添加一个已注册的协议到一个未注册的协议中（只能向未注册的协议中添加）
 *
 *  @param protocol 协议
 *  @param addition 被添加的已注册的协议
 */
- (void)protocol_addProtocol:(Protocol*)protocol addition:(Protocol*)addition {
    protocol_addProtocol(protocol, addition);
}



#pragma mark - Protocol copy：协议列表；属性列表
/**
 *  获取协议中的属性列表
 *
 *  @param protocol 协议
 *
 *  @return 属性
 */
- (objc_property_t *)protocol_copyPropertyList:(Protocol *)protocol {
    unsigned int outCount;
    objc_property_t *propertyList = protocol_copyPropertyList(protocol,&outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        NSLog(@"%s %s",__func__,property_getName(property));
    }
    return propertyList;
}

/**
 *  获取协议中遵循的协议列表
 *
 *  @param protocol 协议
 *
 *  @return 协议列表
 */
- (Protocol **)protocol_copyProtocolList:(Protocol *)protocol {
    unsigned int outCount;
    Protocol **protocolList = protocol_copyProtocolList(protocol,&outCount);
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocolList[i];
        NSLog(@"%s %s",__func__,protocol_getName(protocol));
    }
    return protocolList;
}

/**
 *  获取协议的方法列表
 *
 *  @param protocol         协议
 *  @param isRequiredMethod 是否为必需方法
 *  @param isInstanceMethod 是否为实例方法
 *
 *  @return 方法列表
 */
- (struct objc_method_description *)protocol_copyMethodDescriptionList:(Protocol *)protocol isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod{
    unsigned int outCount;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &outCount);
    for (int i = 0; i < outCount; i++) {
        struct objc_method_description method = methodList[i];
        NSLog(@"%s %@",__func__,NSStringFromSelector(method.name));
    }
    return methodList;
}

#pragma mark - Protocol 判断
/**
 *  测试两个协议是否相等
 *
 *  @param protocol 协议
 *  @param other    另外一个协议
 *
 *  @return 是否相等
 */
- (BOOL)protocol_isEqual:(Protocol *)protocol other:(Protocol *)other {
    BOOL isEqual = protocol_isEqual(protocol, other);
    if (isEqual) {
        NSLog(@"%s %s equal %s ",__func__,protocol_getName(protocol),protocol_getName(other));
    }else{
        NSLog(@"%s %s unequal %s ",__func__,protocol_getName(protocol),protocol_getName(other));
    }
    return isEqual;
}

/**
 *  查看协议是否遵循了另一个协议
 *
 *  @param protocol 协议
 *  @param other    另外一个协议
 *
 *  @return 是否遵循
 */
- (BOOL)protocol_conformsToProtocol:(Protocol *)protocol other:(Protocol *)other {
    BOOL isConform = protocol_conformsToProtocol(protocol, other);
    if (isConform) {
        NSLog(@"%s %s conform %s ",__func__,protocol_getName(protocol),protocol_getName(other));
    }else{
        NSLog(@"%s %s unconform %s ",__func__,protocol_getName(protocol),protocol_getName(other));
    }
    return isConform;
}


#pragma mark - 还未成功调用的方法
/**
 *  调用返回一个数据结构的方法的实现
 *
 *  @param receiver 被调用的对象
 *  @param method   被调用的方法
 */
- (void)method_invoke_stret:(id)receiver method:(Method)method {
//    method_invoke_stret(receiver,method);
}



@end
