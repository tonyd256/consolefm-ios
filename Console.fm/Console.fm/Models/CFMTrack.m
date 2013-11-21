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

    _genreID = json[@"genre_id"];
    _albumArtLarge = [json[@"large_image_url"] copy];
    _albumArtSmall = [json[@"medium_image_url"] copy];
    _source = [NSURL URLWithString:[json[@"track_source_url"] copy]];

    NSString *length = [json[@"length"] copy];

    if (![length isEqual:[NSNull null]]) {
        NSArray *timeArray = [length componentsSeparatedByString:@":"];

        if (timeArray.count >= 2) {
            _duration = [NSNumber numberWithInt:([timeArray[0] intValue] * 60 + [timeArray[1] intValue])];
        }
    } else {
        _duration = @0;
    }

    NSArray *artistsJSON = json[@"artists"];
    CFMArtist *artist = [[CFMArtist alloc] initWithJSON:[artistsJSON firstObject]];
    _artistName = artist.name;

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    _genreID = [aDecoder decodeObjectForKey:@"genreID"];

    _albumArtLarge = [aDecoder decodeObjectForKey:@"albumArtLarge"];
    _albumArtSmall = [aDecoder decodeObjectForKey:@"albumArtSmall"];
    _source = [aDecoder decodeObjectForKey:@"source"];
    _duration = [aDecoder decodeObjectForKey:@"duration"];
    _artistName = [aDecoder decodeObjectForKey:@"artistName"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:self.genreID forKey:@"genreID"];
    [aCoder encodeObject:self.albumArtSmall forKey:@"albumArtSmall"];
    [aCoder encodeObject:self.albumArtLarge forKey:@"albumArtLarge"];
    [aCoder encodeObject:self.source forKey:@"source"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.artistName forKey:@"artistName"];
}

@end
