//
//  CFMArtist.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMArtist.h"
#import "CFMGenre.h"

@implementation CFMArtist

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (!self) return nil;

    _objectId = json[@"id"];
    _name = json[@"name"];
    _slug = json[@"slug"];
    _totalTracks = json[@"total_tracks"];

    NSArray *jsonGenres = json[@"genres"];
    NSMutableArray *genres = [NSMutableArray arrayWithCapacity:jsonGenres.count];

    for (NSDictionary *genre in jsonGenres) {
        [genres addObject:[[CFMGenre alloc] initWithJSON:genre]];
    }

    _genres = [genres copy];

    return self;
}

@end
