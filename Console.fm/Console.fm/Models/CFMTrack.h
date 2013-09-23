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
@property (strong, readonly) NSString *length;
@property (strong, readonly) NSNumber *playbackCount;
@property (strong, readonly) NSString *largeImageUrl;
@property (strong, readonly) NSString *mediumImageUrl;
@property (strong, readonly) NSString *smallImageUrl;
@property (strong, readonly) NSString *trackSourceUrl;
@property (strong, readonly) NSString *canonicalUrl;
@property (strong, readonly) NSArray *artists;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
