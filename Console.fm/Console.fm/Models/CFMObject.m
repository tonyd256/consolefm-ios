//
//  CFMObject.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/22/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMObject.h"

@implementation CFMObject

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (!self || !json) return nil;

    _objectID = [[json[@"id"] stringValue] copy];
    _name = [json[@"name"] copy];

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) return nil;

    _objectID = [aDecoder decodeObjectForKey:@"objectID"];
    _name = [aDecoder decodeObjectForKey:@"name"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.objectID forKey:@"objectID"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
