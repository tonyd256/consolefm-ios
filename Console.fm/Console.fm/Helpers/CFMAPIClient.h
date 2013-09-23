//
//  CFMAPIClient.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^CFMCompletionBlock)(NSError *, NSArray *);

@interface CFMAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)fetchGenresWithCompletion:(CFMCompletionBlock)complete;
- (void)fetchTracksForGenre:(NSString *)genre complete:(CFMCompletionBlock)complete;

@end
