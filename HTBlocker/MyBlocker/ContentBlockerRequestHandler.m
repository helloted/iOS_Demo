//
//  ContentBlockerRequestHandler.m
//  MyBlocker
//
//  Created by iMac on 2017/12/13.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ContentBlockerRequestHandler.h"

@interface ContentBlockerRequestHandler ()

@end

@implementation ContentBlockerRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockerList" withExtension:@"json"]];
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[attachment];
    
    [context completeRequestReturningItems:@[item] completionHandler:nil];
}

@end
