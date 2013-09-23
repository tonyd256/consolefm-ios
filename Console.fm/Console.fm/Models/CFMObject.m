//
//  CFMObject.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/22/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMObject.h"

@implementation CFMObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (!self || !json) return nil;

    _objectID = [[json[@"id"] stringValue] copy];
    _name = [json[@"name"] copy];

    return self;
}

@end
