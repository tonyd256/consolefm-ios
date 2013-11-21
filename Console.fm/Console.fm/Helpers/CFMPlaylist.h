//
//  CFMPlaylist.h
//  Console.fm
//
//  Created by Tony DiPasquale on 11/7/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

@class CFMTrack;

@interface CFMPlaylist : NSObject

@property (strong, nonatomic, readonly) NSArray *playlist;
@property (assign, nonatomic, readonly) NSUInteger currentTrackIndex;
@property (strong, nonatomic, readonly) CFMTrack *currentTrack;

+ (instancetype)sharedPlaylist;

- (void)addTrack:(CFMTrack *)track;
- (void)addTracksFromArray:(NSArray *)tracks;
- (CFMTrack *)trackAtIndex:(NSUInteger)index;

- (void)loadTrackAtIndex:(NSUInteger)index;
- (void)playNextTrack;
- (void)playPreviousTrack;
- (void)removeAllTracks;

@end
