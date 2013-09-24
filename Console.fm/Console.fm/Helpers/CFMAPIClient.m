//
//  CFMAPIClient.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMAPIClient.h"
#import "CFMSessionManager.h"
#import "CFMGenre.h"
#import "CFMTrack.h"

@interface CFMAPIClient ()

@property (strong, nonatomic) CFMSessionManager *manager;

@end

@implementation CFMAPIClient

+ (instancetype)sharedClient
{
    static CFMAPIClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[CFMAPIClient alloc] init];
    });
    return client;
}

- (CFMSessionManager *)manager
{
    if (!_manager) {
        _manager = [[CFMSessionManager alloc] init];
    }

    return _manager;
}

#pragma mark - Request methods

- (void)fetchGenresWithCompletion:(CFMCompletionBlock)complete
{
    [self.manager GET:@"genres" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)fetchTracksForGenre:(id)genre completion:(CFMCompletionBlock)complete
{
    [self.manager GET:[NSString stringWithFormat:@"genres/%@/tracks", genre] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
