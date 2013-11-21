//
//  CFMAudioPlayer.h
//  Console.fm
//
//  Created by Tony DiPasquale on 11/19/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

extern NSString *const CFMAudioPlayerDidChangeTrackNotification;
extern NSString *const CFMAudioPlayerDidPauseNotification;
extern NSString *const CFMAudioPlayerDidPlayNotification;
extern NSString *const CFMAudioPlayerDidStartPlayingNotification;
extern NSString *const CFMAudioPlayerDidFinishPlayingNotification;

@class CFMTrack;

@interface CFMAudioPlayer : NSObject

@property (strong, nonatomic, readonly) CFMTrack *currentTrack;
@property (assign, nonatomic, readonly, getter = isPlaying) BOOL playing;
@property (assign, nonatomic, readonly, getter = isLoading) BOOL loading;

+ (instancetype)sharedAudioPlayer;

- (void)loadTrack:(CFMTrack *)track;

- (void)play;
- (void)pause;
- (void)stop;

@end
