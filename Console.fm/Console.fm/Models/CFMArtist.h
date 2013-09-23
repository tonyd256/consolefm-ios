//
//  CFMArtist.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMObject.h"

@interface CFMArtist : CFMObject

@property (copy, readonly) NSString *slug;
@property (strong, readonly) NSNumber *totalTracks;
@property (copy, readonly) NSSet *genres;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
