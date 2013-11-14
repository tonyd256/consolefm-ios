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

    if (path) {
        NSDictionary *private = [NSDictionary dictionaryWithContentsOfFile:path];
        [TestFlight takeOff:[private objectForKey:@"TestFlight App Token"]];
    }

    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    [[TDAudioPlayer sharedAudioPlayer] handleRemoteControlEvent:event];
}

@end
