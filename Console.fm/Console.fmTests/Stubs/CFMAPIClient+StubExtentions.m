//
//  CFMAPIClient+StubExtentions.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/22/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMAPIClient+StubExtentions.h"
#import "OHHttpStubs.h"

@implementation CFMAPIClient (StubExtentions)

+ (void)stubRequestPath:(NSString *)path method:(NSString *)method filename:(NSString *)filename
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if ([request.HTTPMethod isEqualToString:method] && [request.URL.path rangeOfString:path].location != NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFile:[NSString stringWithFormat:@"%@.json", filename] contentType:@"text/json" responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
}

+ (void)removeLastRequestHandler
{
    [OHHTTPStubs removeLastRequestHandler];
}

@end
