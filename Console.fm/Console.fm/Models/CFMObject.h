//
//  CFMObject.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/22/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

@interface CFMObject : NSObject

@property (strong, readonly) NSString *objectID;
@property (strong, readonly) NSString *name;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
