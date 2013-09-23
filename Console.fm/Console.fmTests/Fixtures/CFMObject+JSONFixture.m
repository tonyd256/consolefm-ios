//
//  CFMObject+JSONFixture.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/22/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMObject+JSONFixture.h"

@implementation CFMObject (JSONFixture)

+ (NSDictionary *)jsonFixture
{
    return @{@"id": @1,
             @"name": @"Test Object"};
}

@end
