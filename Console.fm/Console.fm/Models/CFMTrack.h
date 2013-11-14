//
//  CFMTrack.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

@interface CFMTrack : NSObject <NSCoding>

@property (copy, readonly) NSString *objectID;
@property (strong, readonly) NSNumber *genreID;
@property (strong, nonatomic) NSURL *source;
@property (strong, nonatomic) TDAudioMetaInfo *info;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
