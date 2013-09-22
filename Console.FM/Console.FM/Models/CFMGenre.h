//
//  CFMGenre.h
//  Console.FM
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

@interface CFMGenre : NSObject

@property (copy, readonly) NSNumber *objectId;
@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *slug;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
