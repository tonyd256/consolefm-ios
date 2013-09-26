//
//  CFMTrack.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMObject.h"

@interface CFMTrack : CFMObject

@property (strong, readonly) NSNumber *genreId;
@property (copy, readonly) NSString *length;
@property (strong, readonly) NSNumber *playbackCount;
@property (copy, readonly) NSString *largeImageUrl;
@property (copy, readonly) NSString *mediumImageUrl;
@property (copy, readonly) NSString *smallImageUrl;
@property (copy, readonly) NSString *trackSourceUrl;
@property (copy, readonly) NSString *canonicalUrl;
@property (copy, readonly) NSArray *artists;

- (instancetype)initWithJSON:(NSDictionary *)json;
- (NSString *)artistName;

@end
