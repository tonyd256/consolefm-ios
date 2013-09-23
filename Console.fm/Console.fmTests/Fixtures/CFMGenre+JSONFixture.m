//
//  CFMGenre+JSONFixture.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMGenre+JSONFixture.h"

@implementation CFMGenre (JSONFixture)

+ (NSDictionary *)jsonFixture
{
    return @{@"id": @1,
             @"name": @"Test Genre",
             @"slug": @"test-genre"};
}

@end
