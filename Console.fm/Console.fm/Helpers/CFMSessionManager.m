//
//  CFMSessionManager.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/23/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMSessionManager.h"

static NSString *kAPIBaseURL = @"http://console.fm/api/v2/";

@interface CFMSessionManager ()

@property (strong, nonatomic) NSString *apiKey;

@end

@implementation CFMSessionManager

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
    if (!self) return nil;

    return self;
}

#pragma mark - Properties

- (NSString *)apiKey
{
    if (!_apiKey) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"private" ofType:@"plist"];
//        if (path) {
//            NSDictionary *private = [NSDictionary dictionaryWithContentsOfFile:path];
//            _apiKey = [private objectForKey:@"Console.fm API Key"];
//        } else {
            _apiKey = @"public_limited";
//        }
    }

    return _apiKey;
}

#pragma mark - Subclass Overrides

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:YES];
    NSMutableURLRequest *newRequest = [request mutableCopy];
    components.query = [@"api_key=" stringByAppendingString:self.apiKey];
    newRequest.URL = components.URL;

    return [super dataTaskWithRequest:[newRequest copy] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error
            || ![responseObject isKindOfClass:[NSDictionary class]]
            || ([responseObject isKindOfClass:[NSDictionary class]]
                && ![responseObject objectForKey:@"error"])
            ) {
            return completionHandler(response, responseObject, error);
        }

        NSError *newError = [NSError errorWithDomain:@"APIError" code:-1 userInfo:@{NSLocalizedDescriptionKey: [[responseObject objectForKey:@"error"] objectForKey:@"message"]}];
        return completionHandler(response, responseObject, newError);
    }];
}

@end
