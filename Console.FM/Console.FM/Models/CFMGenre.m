//
//  CFMGenre.m
//  Console.FM
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMGenre.h"

@implementation CFMGenre

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (!self) return nil;

    _objectId = json[@"id"];
    _name = json[@"name"];
    _slug = json[@"slug"];
    
    return self;
}

@end
