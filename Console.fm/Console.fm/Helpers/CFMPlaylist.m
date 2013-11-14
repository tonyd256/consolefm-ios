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

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.trackList = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextTrack:) name:TDAudioPlayerNextTrackRequestNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playPreviousTrack:) name:TDAudioPlayerPreviousTrackRequestNotification object:nil];

    return self;
}

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

#pragma mark - Properties

- (CFMTrack *)currentTrack
{
    return self.trackList[self.currentTrackIndex];
}

- (NSArray *)playlist
{
    return [self.trackList copy];
}

- (void)loadTrackAtIndex:(NSUInteger)index
{
    if (index >= self.playlist.count) return;

    CFMTrack *track = self.playlist[index];
    [[TDAudioPlayer sharedAudioPlayer] loadAudioFromURL:track.source withMetaData:track.info];
    self.currentTrackIndex = index;
}

- (void)playNextTrack:(NSNotification *)notification
{
    if (self.currentTrackIndex + 1 >= self.playlist.count) return;

    [self loadTrackAtIndex:(self.currentTrackIndex + 1)];
    [[TDAudioPlayer sharedAudioPlayer] play];
}

- (void)playPreviousTrack:(NSNotification *)notification
{
    if (self.currentTrackIndex == 0) return;

    [self loadTrackAtIndex:(self.currentTrackIndex - 1)];
    [[TDAudioPlayer sharedAudioPlayer] play];
}

- (void)removeAllTracks
{
    [self.trackList removeAllObjects];
}

@end
