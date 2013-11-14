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
    _genreID = json[@"genre_id"];

    self.info = [[TDAudioMetaInfo alloc] init];
    self.info.title = [json[@"name"] copy];
    self.info.albumArtLarge = [json[@"large_image_url"] copy];
    self.info.albumArtSmall = [json[@"medium_image_url"] copy];
    self.source = [NSURL URLWithString:[json[@"track_source_url"] copy]];

    NSString *length = [json[@"length"] copy];

    if (![length isEqual:[NSNull null]]) {
        NSArray *timeArray = [length componentsSeparatedByString:@":"];

        if (timeArray.count >= 2) {
            self.info.duration = [NSNumber numberWithInt:([timeArray[0] intValue] * 60 + [timeArray[1] intValue])];
        }
    } else {
        self.info.duration = @0;
    }

    NSArray *artistsJSON = json[@"artists"];
    CFMArtist *artist = [[CFMArtist alloc] initWithJSON:[artistsJSON firstObject]];
    self.info.artist = artist.name;

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) return nil;

    _objectID = [aDecoder decodeObjectForKey:@"objectID"];
    _genreID = [aDecoder decodeObjectForKey:@"genreID"];

    self.info = [[TDAudioMetaInfo alloc] init];
    self.info.title = [aDecoder decodeObjectForKey:@"info.title"];
    self.info.albumArtLarge = [aDecoder decodeObjectForKey:@"info.albumArtLarge"];
    self.info.albumArtSmall = [aDecoder decodeObjectForKey:@"info.albumArtSmall"];
    self.source = [aDecoder decodeObjectForKey:@"source"];
    self.info.duration = [aDecoder decodeObjectForKey:@"info.duration"];
    self.info.artist = [aDecoder decodeObjectForKey:@"info.artist"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_objectID forKey:@"objectID"];
    [aCoder encodeObject:_genreID forKey:@"genreID"];
    [aCoder encodeObject:self.info.title forKey:@"info.title"];
    [aCoder encodeObject:self.info.albumArtSmall forKey:@"info.albumArtSmall"];
    [aCoder encodeObject:self.info.albumArtLarge forKey:@"info.albumArtLarge"];
    [aCoder encodeObject:self.source forKey:@"source"];
    [aCoder encodeObject:self.info.duration forKey:@"info.duration"];
    [aCoder encodeObject:self.info.artist forKey:@"info.artist"];
}

@end
