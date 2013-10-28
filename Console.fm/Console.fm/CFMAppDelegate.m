//
//  CFMAppDelegate.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/20/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMAppDelegate.h"
#import "TestFlight.h"

@implementation CFMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"private" ofType:@"plist"];
    NSDictionary *private = [NSDictionary dictionaryWithContentsOfFile:path];

    [TestFlight takeOff:[private objectForKey:@"TestFlight App Token"]];

    return YES;
}

@end
