//
//  CFMArtistSpec.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright 2013 Simple Casual. All rights reserved.
//

#import "CFMArtist+JSONFixture.h"

SPEC_BEGIN(CFMArtistSpec)

describe(@"CFMArtist", ^{
    describe(@"initWithJSON:", ^{
        it(@"should create artist model from JSON", ^{
            CFMArtist *artist = [[CFMArtist alloc] initWithJSON:[CFMArtist jsonFixture]];
            [[artist.name should] equal:@"Test Artist"];
            [[theValue(artist.genres.count) should] equal:theValue(1)];
        });
    });
});

SPEC_END
