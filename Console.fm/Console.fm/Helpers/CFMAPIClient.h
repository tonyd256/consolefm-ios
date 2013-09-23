//
//  CFMAPIClient.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

typedef void (^CFMCompletionBlock)(NSError *, NSArray *);

@interface CFMAPIClient : NSObject

+ (void)fetchGenresWithCompletion:(CFMCompletionBlock)complete;
+ (void)fetchTracksForGenre:(NSString *)genre completion:(CFMCompletionBlock)complete;

@end
