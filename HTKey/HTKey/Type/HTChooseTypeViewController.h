//
//  HTChooseTypeViewController.h
//  HTKey
//
//  Created by iMac on 2018/1/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "HTSuperViewController.h"

@protocol HTChooseVCDelegate <NSObject>
- (void)didSelectType:(NSString *)type;
@end

@interface HTChooseTypeViewController : HTSuperViewController

@property (nonatomic, weak)id<HTChooseVCDelegate> delegate;

@end
