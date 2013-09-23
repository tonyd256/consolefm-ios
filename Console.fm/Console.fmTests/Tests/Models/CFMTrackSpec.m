//
//  CFMTrackSpec.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright 2013 Simple Casual. All rights reserved.
//

#import "CFMTrack+JSONFixture.h"

SPEC_BEGIN(CFMTrackSpec)

describe(@"CFMTrack", ^{
    describe(@"initWithJSON:", ^{
        it(@"should create a track model from JSON", ^{
            CFMTrack *track = [[CFMTrack alloc] initWithJSON:[CFMTrack jsonFixture]];
            [[track.name should] equal:@"Test Track"];
        });
    });
});

SPEC_END
