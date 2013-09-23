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
        return [request.HTTPMethod isEqualToString:method] && [request.URL.path rangeOfString:path].location != NSNotFound;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFile:[NSString stringWithFormat:@"%@.json", filename] contentType:@"text/json" responseTime:OHHTTPStubsDownloadSpeedWifi];
    }];
}

+ (void)removeLastRequestHandler
{
    [OHHTTPStubs removeLastRequestHandler];
}

@end
