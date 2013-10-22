//
//  CFMTrack.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "TDTrack.h"

@interface CFMTrack : TDTrack

@property (copy, readonly) NSString *objectID;
@property (strong, readonly) NSNumber *genreId;
@property (copy, readonly) NSString *length;
@property (strong, readonly) NSNumber *playbackCount;
@property (copy, readonly) NSString *canonicalUrl;
@property (copy, readonly) NSArray *artists;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
