//
//  CFMGenreSpec.m
//  Console.FM
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright 2013 Simple Casual. All rights reserved.
//

#import "CFMGenre+JSONFixture.h"

SPEC_BEGIN(CFMGenreSpec)

describe(@"CFMGenre", ^{
    describe(@"initWithJSON:", ^{
        it(@"should create a genre model from JSON", ^{
            CFMGenre *genre = [[CFMGenre alloc] initWithJSON:[CFMGenre jsonFixture]];
            [[genre.name should] equal:@"Test Genre"];
        });
    });
});

SPEC_END
