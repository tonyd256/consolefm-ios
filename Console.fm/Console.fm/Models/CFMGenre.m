//
//  CFMGenre.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMGenre.h"

@implementation CFMGenre

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super initWithJSON:json];
    if (!self) return nil;

    _slug = [json[@"slug"] copy];
    
    return self;
}

@end
