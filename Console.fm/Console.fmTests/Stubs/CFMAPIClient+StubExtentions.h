//
//  CFMAPIClient+StubExtentions.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/22/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMAPIClient.h"

@interface CFMAPIClient (StubExtentions)

+ (void)stubRequestPath:(NSString *)path method:(NSString *)method filename:(NSString *)filename;
+ (void)removeLastRequestHandler;

@end
