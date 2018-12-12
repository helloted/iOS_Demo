//
//  HTItemModel.h
//  UITableViewDemo
//
//  Created by iMac on 2018/4/3.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTItemCellMargin            10
#define HTItemCellImageViewMargin   15
#define HTItemCellImageViewSize     ((UI_WIDTH - 2 * HTItemCellMargin - 2 * HTItemCellImageViewMargin) / 3.0)

@interface HTItemModel : NSObject

@property (nonatomic, copy)NSString  *nickName;
@property (nonatomic, copy)NSString  *nickIcon;
@property (nonatomic, copy)NSString  *fromClient;
@property (nonatomic, copy)NSString  *content;

@property (nonatomic, copy)NSArray  *imgArray;

@property (nonatomic, assign)NSInteger    upCount;
@property (nonatomic, assign)NSInteger    forwardCount;
@property (nonatomic, assign)NSInteger    commentCount;

@property (nonatomic, assign)NSInteger    postTime;

@property (nonatomic, assign)CGFloat      contentHeight;


@end
