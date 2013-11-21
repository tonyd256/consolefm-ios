//
//  CFMPlaylist.m
//  Console.fm
//
//  Created by Tony DiPasquale on 11/7/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMPlaylist.h"
#import "CFMTrack.h"

@interface CFMPlaylist ()

@property (strong, nonatomic) NSMutableArray *trackList;
@property (assign, nonatomic) NSUInteger currentTrackIndex;

@end

@implementation CFMPlaylist

+ (instancetype)sharedPlaylist
{
    static CFMPlaylist *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[CFMPlaylist alloc] init];
    });
    return shared;
}

#pragma mark - Public Methods

- (void)addTrack:(CFMTrack *)track
{
    [self.trackList addObject:track];
}

- (void)addTracksFromArray:(NSArray *)tracks
{
    [self.trackList addObjectsFromArray:tracks];
}

- (CFMTrack *)trackAtIndex:(NSUInteger)index
{
    if (index >= self.playlist.count) return nil;
    return self.playlist[index];
}

- (void)loadTrackAtIndex:(NSUInteger)index
{
    if (index >= self.playlist.count) return;

    self.currentTrackIndex = index;
    CFMTrack *track = self.playlist[index];
    [[CFMAudioPlayer sharedAudioPlayer] loadTrack:track];
}

- (void)playNextTrack
{
    if (self.currentTrackIndex + 1 >= self.playlist.count) return;

    [self loadTrackAtIndex:(self.currentTrackIndex + 1)];
    [[CFMAudioPlayer sharedAudioPlayer] play];
}

- (void)playPreviousTrack
{
    if (self.currentTrackIndex == 0) return;

    [self loadTrackAtIndex:(self.currentTrackIndex - 1)];
    [[CFMAudioPlayer sharedAudioPlayer] play];
}

- (void)removeAllTracks
{
    [self.trackList removeAllObjects];
}

#pragma mark - Properties

- (NSMutableArray *)trackList
{
    if (!_trackList)
        _trackList = [NSMutableArray array];

    return _trackList;
}

- (CFMTrack *)currentTrack
{
    return self.trackList[self.currentTrackIndex];
}

- (NSArray *)playlist
{
    return [self.trackList copy];
}

@end
