//
//  CFMObjectSpec.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/22/13.
//  Copyright 2013 Simple Casual. All rights reserved.
//

#import "CFMObject+JSONFixture.h"

SPEC_BEGIN(CFMObjectSpec)

describe(@"CFMObject", ^{
    describe(@"initWithJSON:", ^{
        it(@"should create an object from JSON", ^{
            CFMObject *object = [[CFMObject alloc] initWithJSON:[CFMObject jsonFixture]];
            [[object.name should] equal:@"Test Object"];
        });

        it(@"should return nil if the JSON is nil", ^{
            CFMObject *object = [[CFMObject alloc] initWithJSON:nil];
            [[object should] beNil];
        });
    });
});

SPEC_END
