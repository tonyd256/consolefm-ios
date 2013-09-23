//
//  CFMAPIClientSpec.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright 2013 Simple Casual. All rights reserved.
//

#import "CFMAPIClient+StubExtentions.h"

SPEC_BEGIN(CFMAPIClientSpec)

describe(@"CFMAPIClient", ^{
    describe(@"fetchGenresWithCompletion:", ^{
        __block NSArray *returnedGenres;

        it(@"should return a list of genres from the api", ^{
            [CFMAPIClient stubRequestPath:@"genres" method:@"GET" filename:@"genres"];
            [[CFMAPIClient sharedClient] fetchGenresWithCompletion:^(NSError *error, NSArray *genres) {
                returnedGenres = genres;
            }];

            [[expectFutureValue(returnedGenres) shouldEventually] beNonNil];
        });
    });

    describe(@"fetchTracksForGenre:complete:", ^{
        __block NSArray *returnedTracks;

        it(@"should return a list of tracks for a given genre from the api", ^{
            [CFMAPIClient stubRequestPath:@"genres/1/tracks" method:@"GET" filename:@"tracks"];
            [[CFMAPIClient sharedClient] fetchTracksForGenre:@"1" complete:^(NSError *error, NSArray *tracks) {
                returnedTracks = tracks;
            }];

            [[expectFutureValue(returnedTracks) shouldEventually] beNonNil];
        });
    });
});

SPEC_END
