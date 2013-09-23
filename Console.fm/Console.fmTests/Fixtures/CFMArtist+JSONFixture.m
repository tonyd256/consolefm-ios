//
//  CFMArtist+JSONFixture.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMArtist+JSONFixture.h"
#import "CFMGenre+JSONFixture.h"

@implementation CFMArtist (JSONFixture)

+ (NSDictionary *)jsonFixture
{
    return @{@"id": @1,
             @"name": @"Test Artist",
             @"slug": @"test-artist",
             @"total_tracks": @2,
             @"genres": @[[CFMGenre jsonFixture]]};
}

@end
