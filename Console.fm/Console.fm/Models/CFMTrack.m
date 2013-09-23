//
//  CFMTrack.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMTrack.h"
#import "CFMArtist.h"

@implementation CFMTrack

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (!self) return nil;

    _objectId = json[@"id_str"];
    _genreId = json[@"genre_id"];
    _name = json[@"name"];
    _length = json[@"length"];
    _playbackCount = json[@"playback_count"];
    _largeImageUrl = json[@"large_image_url"];
    _mediumImageUrl = json[@"medium_image_url"];
    _smallImageUrl = json[@"small_image_url"];
    _trackSourceUrl = json[@"track_source_url"];
    _canonicalUrl = json[@"canonical_url"];

    NSArray *artistsJSON = json[@"artists"];
    NSMutableArray *artists = [NSMutableArray arrayWithCapacity:artistsJSON.count];

    for (NSDictionary *artist in artistsJSON) {
        [artists addObject:[[CFMArtist alloc] initWithJSON:artist]];
    }

    _artists = [artists copy];

    return self;
}

@end
