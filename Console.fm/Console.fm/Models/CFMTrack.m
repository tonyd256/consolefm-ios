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

    _objectID = [[json[@"id"] stringValue] copy];
    _genreId = json[@"genre_id"];

    self.title = [json[@"name"] copy];
    self.albumArtLarge = [json[@"large_image_url"] copy];
    self.albumArtSmall = [json[@"medium_image_url"] copy];
    self.source = [NSURL URLWithString:[json[@"track_source_url"] copy]];

    NSString *length = [json[@"length"] copy];

    if (![length isEqual:[NSNull null]]) {
        NSArray *timeArray = [length componentsSeparatedByString:@":"];

        if (timeArray.count >= 2) {
            self.duration = [timeArray[0] intValue] * 60 + [timeArray[1] intValue];
        }
    }

    NSArray *artistsJSON = json[@"artists"];
    NSMutableArray *artists = [NSMutableArray arrayWithCapacity:artistsJSON.count];

    for (NSDictionary *artist in artistsJSON) {
        [artists addObject:[[CFMArtist alloc] initWithJSON:artist]];
    }

    _artists = [artists copy];

    self.artist = ((CFMArtist *)[_artists firstObject]).name;

    return self;
}

@end
