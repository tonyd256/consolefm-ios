//
//  CFMAPIClient.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMAPIClient.h"
#import "CFMGenre.h"
#import "CFMTrack.h"

static NSString *kAPIBaseURL = @"http://console.fm/api/v2/";

@interface CFMAPIClient ()

@property (strong, nonatomic) NSString *apiKey;

@end

@implementation CFMAPIClient

+ (instancetype)sharedClient
{
    static CFMAPIClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[CFMAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]];
    });
    return client;
}

#pragma mark - Properties

- (NSString *)apiKey
{
    if (!_apiKey) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"private" ofType:@"plist"];
        NSDictionary *private = [NSDictionary dictionaryWithContentsOfFile:path];
        _apiKey = [private objectForKey:@"Console.fm API Key"];
    }

    return _apiKey;
}

#pragma mark - Helpers

- (NSError *)checkForError:(id)response
{
    if (![response objectForKey:@"error"]) return nil;

    return [NSError errorWithDomain:@"API-Error" code:-1 userInfo:@{NSLocalizedDescriptionKey: [[response objectForKey:@"error"] objectForKey:@"message"]}];
}

#pragma mark - Subclass Overrides

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler
{
    NSMutableURLRequest *req = [request mutableCopy];
    NSString *apiKey = [@"?api_key=" stringByAppendingString:self.apiKey];
    req.URL = [NSURL URLWithString:apiKey relativeToURL:req.URL];
    return [super dataTaskWithRequest:req completionHandler:completionHandler];
}

#pragma mark - Request methods

- (void)fetchGenresWithCompletion:(CFMCompletionBlock)complete
{
    [self GET:@"genres" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [self checkForError:responseObject];
        if (error) return complete(error, nil);

        NSArray *genresJSON = [[responseObject objectForKey:@"response"] objectForKey:@"genres"];
        NSMutableArray *genres = [NSMutableArray arrayWithCapacity:genresJSON.count];

        for (NSDictionary *genre in genresJSON) {
            [genres addObject:[[CFMGenre alloc] initWithJSON:genre]];
        }

        complete(nil, [genres copy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        complete(error, nil);
    }];
}

- (void)fetchTracksForGenre:(id)genre complete:(CFMCompletionBlock)complete
{
    [self GET:[NSString stringWithFormat:@"genres/%@/tracks", genre] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error = [self checkForError:responseObject];
        if (error) return complete(error, nil);

        NSArray *tracksJSON = [[responseObject objectForKey:@"response"] objectForKey:@"tracks"];
        NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:tracksJSON.count];

        for (NSDictionary *track in tracksJSON) {
            [tracks addObject:[[CFMTrack alloc] initWithJSON:track]];
        }

        complete(nil, [tracks copy]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        complete(error, nil);
    }];
}

@end
