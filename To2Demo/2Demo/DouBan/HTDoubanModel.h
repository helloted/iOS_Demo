//
//  HTDoubanModel.h
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDoubanModel : NSObject

// 中文名称
@property (nonatomic,copy)NSString          *title;

// 标签
@property (nonatomic,copy)NSArray           *genres;
@property (nonatomic, copy)NSString         *mark;

// 电影海报图
@property (nonatomic, copy)NSDictionary     *images;
@property (nonatomic, copy)NSString         *icon;

// 评分
@property (nonatomic, copy)NSDictionary     *rating;
@property (nonatomic, assign)CGFloat        average;
@property (nonatomic, assign)BOOL           single;

// 导演
@property (nonatomic, copy)NSArray          *directors;
@property (nonatomic, copy)NSString         *directorImg;

@property (nonatomic, copy)NSArray          *casts;
@property (nonatomic, copy)NSArray          *catsImgs;

@end
