//
//  HTDoubanModel.m
//  2Demo
//
//  Created by iMac on 2018/5/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTDoubanModel.h"
#import "NSDictionary+HTSafe.h"
#import "NSNull+HTObject.h"

@implementation HTDoubanModel

- (void)setImages:(NSDictionary *)images{
    _images = images;
    _icon = [images objectForKey:@"small"];
}

- (void)setGenres:(NSArray *)genres{
    _genres = genres;
    NSMutableString *mutalmark = [NSMutableString stringWithFormat:@"标签:"];
    [genres enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == (genres.count-1)) {
            [mutalmark appendFormat:@"%@",obj];
        }else{
            [mutalmark appendFormat:@"%@/",obj];
        }
    }];
    _mark = mutalmark;
}

- (void)setRating:(NSDictionary *)rating{
    _rating = rating;
    NSNumber *av = [rating objectForKey:@"average"];
    _average = [av floatValue];
    NSString *avStr = [av stringValue];
    NSRange range = [avStr rangeOfString:@"."];
    if (range.length == 0) {
        _single = NO;
    }else{
        NSString *result = [avStr substringWithRange:NSMakeRange(range.location+1, 1)];
        if ([result integerValue] % 2 == 0) {
            _single = NO;
        }else{
            _single = YES;
        }
    }
}

- (void)setDirectors:(NSArray *)directors{
    _directors = directors;
    NSDictionary *temp = [directors firstObject];
    NSDictionary *avatars = [temp objectForKey:@"avatars"];
    _directorImg = [avatars objectForKey:@"small"];
}

- (void)setCasts:(NSArray *)casts{
    _casts = casts;
    NSMutableArray *tempArray = [NSMutableArray array];
    [casts enumerateObjectsUsingBlock:^(NSDictionary *temp, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *avatars = [temp objectForKey:@"avatars"];
        NSString *img = [avatars objectForKey:@"small"];
        [tempArray addObject:img];
    }];
    
    _catsImgs = tempArray;
}

@end
