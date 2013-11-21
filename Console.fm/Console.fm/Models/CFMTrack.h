//
//  CFMTrack.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMObject.h"

@interface CFMTrack : CFMObject <NSCoding>

@property (strong, readonly) NSNumber *genreID;
@property (copy, readonly) NSString *albumArtLarge;
@property (copy, readonly) NSString *albumArtSmall;
@property (strong, readonly) NSURL *source;
@property (strong, readonly) NSNumber *duration;
@property (copy, readonly) NSString *artistName;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
