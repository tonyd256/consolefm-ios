//
//  CFMTrack.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "TDTrack.h"

@interface CFMTrack : NSObject <TDTrack, NSCoding>

@property (copy, readonly) NSString *objectID;
@property (strong, readonly) NSNumber *genreID;
@property (copy, readonly) NSArray *artists;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSURL *source;
@property (strong, nonatomic) NSString *albumArtSmall;
@property (strong, nonatomic) NSString *albumArtLarge;
@property (strong, nonatomic) NSNumber *duration;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
