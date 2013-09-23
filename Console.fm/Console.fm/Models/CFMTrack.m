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
    self = [super initWithJSON:json];
    if (!self) return nil;

    _genreId = json[@"genre_id"];
    _length = [json[@"length"] copy];
    _playbackCount = json[@"playback_count"];
    _largeImageUrl = [json[@"large_image_url"] copy];
    _mediumImageUrl = [json[@"medium_image_url"] copy];
    _smallImageUrl = [json[@"small_image_url"] copy];
    _trackSourceUrl = [json[@"track_source_url"] copy];
    _canonicalUrl = [json[@"canonical_url"] copy];

    NSArray *artistsJSON = json[@"artists"];
    NSMutableArray *artists = [NSMutableArray arrayWithCapacity:artistsJSON.count];

    for (NSDictionary *artist in artistsJSON) {
        [artists addObject:[[CFMArtist alloc] initWithJSON:artist]];
    }

    _artists = [artists copy];

    return self;
}

@end
