//
//  CFMGenre.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#include "CFMObject.h"

@interface CFMGenre : CFMObject

@property (strong, readonly) NSString *slug;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
