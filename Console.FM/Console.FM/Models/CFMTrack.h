//
//  CFMTrack.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

@interface CFMTrack : NSObject

@property (copy, readonly) NSString *objectId;
@property (copy, readonly) NSString *name;
@property (copy, readonly) NSNumber *genreId;
@property (copy, readonly) NSString *length;
@property (copy, readonly) NSNumber *playbackCount;
@property (copy, readonly) NSString *largeImageUrl;
@property (copy, readonly) NSString *mediumImageUrl;
@property (copy, readonly) NSString *smallImageUrl;
@property (copy, readonly) NSString *trackSourceUrl;
@property (copy, readonly) NSString *canonicalUrl;
@property (strong, readonly) NSArray *artists;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
