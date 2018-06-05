//
//  MyURLProtocol.m
//  NSURLProtocolExample
//
//  Created by Rocir Marcos Leite Santiago on 11/29/13.
//  Copyright (c) 2013 Rocir Santiago. All rights reserved.
//

#import "MyURLProtocol.h"

// AppDelegate
#import "AppDelegate.h"


static NSString * const MyURLProtocolHandledKey = @"MyURLProtocolHandledKey";

@interface MyURLProtocol () <NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSURLSession  *session;

@end

@implementation MyURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if ([NSURLProtocol propertyForKey:MyURLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void) startLoading {
    
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:MyURLProtocolHandledKey inRequest:newRequest];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    config.connectionProxyDictionary = @
    {
        @"HTTPEnable":@YES,
        (id)kCFStreamPropertyHTTPProxyHost:@"36.33.23.18",
        (id)kCFStreamPropertyHTTPProxyPort:@6436,
        @"HTTPSEnable":@YES,
        (id)kCFStreamPropertyHTTPSProxyHost:@"36.33.23.18",
        (id)kCFStreamPropertyHTTPSProxyPort:@6436
    };
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    [[_session dataTaskWithRequest:newRequest] resume];
    
}

- (void) stopLoading {
    [self.connection cancel];
    self.mutableData = nil;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    self.response = response;
    self.mutableData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.mutableData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - Private



@end
