//
//  HTHTTPConnection.m
//  HTTPServer
//
//  Created by iMac on 2018/7/3.
//  Copyright © 2018年 HT. All rights reserved.
//

#import "HTHTTPConnection.h"
#import <HTTPLogging.h>
#import <HTTPMessage.h>
#import <HTTPDataResponse.h>
#import <DDNumber.h>

#import <HTTPDynamicFileResponse.h>
#import <HTTPFileResponse.h>
#import <MultipartMessageHeaderField.h>
#import <MultipartFormDataParser.h> 

// Log levels : off, error, warn, info, verbose
// Other flags : trace
static const int httpLogLevel = HTTP_LOG_LEVEL_VERBOSE; // | HTTP_LOG_FLAG_TRACE

@interface HTHTTPConnection()<MultipartFormDataParserDelegate>

@property (nonatomic, copy)NSString             *filePath;
@property (nonatomic, strong)NSMutableData      *receivedData;

@end

@implementation HTHTTPConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    HTTPLogTrace();
    
    if ([method isEqualToString:@"POST"]) {
        if ([path isEqualToString:@"/upload.html"]) {
            return YES;
        }
    }
    return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path {
    HTTPLogTrace();
    
    // Inform HTTP server that we expect a body to accompany a POST request
    
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/upload.html"]) {
        // here we need to make sure, boundary is set in header
        NSString *contentType = [request headerField:@"Content-Type"];
        NSUInteger paramsSeparator = [contentType rangeOfString:@";"].location;
        if (NSNotFound == paramsSeparator) {
            return NO;
        }
        if (paramsSeparator >= contentType.length - 1) {
            return NO;
        }
        NSString *type = [contentType substringToIndex:paramsSeparator];
        if (![type isEqualToString:@"multipart/form-data"]) {
            // we expect multipart/form-data content type
            return NO;
        }
        
        // enumerate all params in content-type, and find boundary there
        NSArray *params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];
        for (NSString *param in params) {
            paramsSeparator = [param rangeOfString:@"="].location;
            if (NSNotFound == paramsSeparator || paramsSeparator >= param.length - 1) {
                continue;
            }
            NSString *paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator - 1)];
            NSString *paramValue = [param substringFromIndex:paramsSeparator + 1];
            if ([paramName isEqualToString:@"boundary"]) {
                // let's separate the boundary from content-type, to make it more handy to handle
                [request setHeaderField:@"boundary" value:paramValue];
            }
        }
        // check if boundary specified
        if ([request headerField:@"boundary"] == nil) {
            return NO;
        }
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    HTTPLogTrace();
    
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/upload.html"]) {
        // this method will generate response with links to uploaded file
        NSMutableString *filesStr = [[NSMutableString alloc] init];
        for (NSString *filePath in uploadedFiles) {
            // generate links
            [filesStr appendFormat:@"<a href=\"%@\"> %@ </a><br/>", filePath, [filePath lastPathComponent]];
        }
        NSString *templatePath = [[config documentRoot] stringByAppendingPathComponent:@"upload.html"];
        NSDictionary *replacementDict = [NSDictionary dictionaryWithObject:filesStr forKey:@"MyFiles"];
        // use dynamic file response to apply our links to response template
        return [[HTTPDynamicFileResponse alloc] initWithFilePath:templatePath forConnection:self separator:@"%" replacementDictionary:replacementDict];
    }
    if ([method isEqualToString:@"GET"] && [path hasPrefix:@"/upload/"]) {
        // let download the uploaded files
        return [[HTTPFileResponse alloc] initWithFilePath:[[config documentRoot] stringByAppendingString:path] forConnection:self];
    }
    return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength {
    HTTPLogTrace();
    
    // set up mine parser
    NSString *boundary = [request headerField:@"boundary"];
    parser = [[MultipartFormDataParser alloc] initWithBoundary:boundary formEncoding:NSUTF8StringEncoding];
    parser.delegate = self;
    uploadedFiles = [[NSMutableArray alloc] init];
}

- (void)processBodyData:(NSData *)postDataChunk {
    HTTPLogTrace();
    // append data to the parser. It will invoke callbacks to let us handle
    // parsed data.
    [parser appendData:postDataChunk];
}

#pragma mark -- 接受数据的代理
- (void)processStartOfPartWithHeader:(MultipartMessageHeader *)header {
    // 获取上传的文件名称
    MultipartMessageHeaderField *disposition = [header.fields objectForKey:@"Content-Disposition"];
    NSString *filename = [[disposition.params objectForKey:@"filename"] lastPathComponent];
    if (filename == nil || [filename isEqualToString:@""]) {
        return;
    }

    // 上传的文件存放的位置
    NSString *uploadDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil]) {
        NSLog(@"Could not create directory at path: %@", uploadDirPath);
    }
    
    _filePath = [uploadDirPath stringByAppendingPathComponent:filename];
    _receivedData = [NSMutableData data];
}

- (void)processContent:(NSData *)data WithHeader:(MultipartMessageHeader *)header {
    [_receivedData appendData:data];
}

- (void)processEndOfPartWithHeader:(MultipartMessageHeader *)header {
    [_receivedData writeToFile:_filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedFileNotification" object:nil];
}

- (void)processPreambleData:(NSData *)data {
    // if we are interested in preamble data, we could process it here.
}

- (void)processEpilogueData:(NSData *)data {
    // if we are interested in epilogue data, we could process it here
}

@end
