//
//  HTHTTPConnection.h
//  HTTPServer
//
//  Created by iMac on 2018/7/3.
//  Copyright © 2018年 HT. All rights reserved.
//

#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface HTHTTPConnection : HTTPConnection{
    MultipartFormDataParser *parser;
    NSFileHandle *storeFile;
    NSMutableArray *uploadedFiles;
    
}


@end
