//
//  CFMTrack+JSONFixture.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMTrack+JSONFixture.h"
#import "CFMArtist+JSONFixture.h"

@implementation CFMTrack (JSONFixture)

+ (NSDictionary *)jsonFixture
{
    return @{@"genre_id": @1,
             @"id_str": @"kris-wadsworth-connection",
             @"large_image_url": @"http://geo-media.beatport.com/items/imageCatalog/4000000/100000/0/7000/400/70/4107471.jpg",
             @"length": @"7:01",
             @"medium_image_url": @"http://geo-media.beatport.com/items/imageCatalog/4000000/100000/0/7000/400/70/4107470.jpg",
             @"name": @"Test Track",
             @"playback_count": @413,
             @"published_at": @"2011-10-03T00:00:00Z",
             @"released_at": @"2011-10-03T00:00:00Z",
             @"small_image_url": @"http://geo-media.beatport.com/items/imageCatalog/4000000/100000/0/7000/400/60/4107469.jpg",
             @"track_source_url": @"http://console.fm/media/ajupgmlzlgntjkomekveoxrur",
             @"canonical_url": @"http://console.fm/tracks/kris-wadsworth-connection",
             @"artists": @[[CFMArtist jsonFixture]]};
}

@end
