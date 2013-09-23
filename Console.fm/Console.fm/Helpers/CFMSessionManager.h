//
//  CFMSessionManager.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/23/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CFMSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
