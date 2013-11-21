//
//  CFMAudioPlayer.m
//  Console.fm
//
//  Created by Tony DiPasquale on 11/19/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

@import AVFoundation;
@import MediaPlayer;

#import "CFMAudioPlayer.h"
#import "CFMTrack.h"

NSString *const CFMAudioPlayerDidChangeTrackNotification = @"CFMAudioPlayerDidChangeTrackNotification";
NSString *const CFMAudioPlayerDidPauseNotification = @"CFMAudioPlayerDidPauseNotification";
NSString *const CFMAudioPlayerDidPlayNotification = @"CFMAudioPlayerDidPlayNotification";
NSString *const CFMAudioPlayerDidStartPlayingNotification = @"CFMAudioPlayerDidStartPlayingNotification";
NSString *const CFMAudioPlayerDidFinishPlayingNotification = @"CFMAudioPlayerDidFinishPlayingNotification";

@interface CFMAudioPlayer ()

@property (strong, nonatomic) CFMTrack *currentTrack;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) NSMutableDictionary *nowPlayingInfo;

@property (assign, nonatomic) BOOL playing;
@property (assign, nonatomic) BOOL loading;

@end

@implementation CFMAudioPlayer

+ (instancetype)sharedAudioPlayer
{
    static CFMAudioPlayer *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[CFMAudioPlayer alloc] init];
    });

    return shared;
}

- (instancetype)init
{
    self = [super self];
    if (!self) return nil;

    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionDidInterrupt:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionDidChangeRoute:) name:AVAudioSessionRouteChangeNotification object:nil];

    return self;
}

#pragma mark - Public Methods

- (void)loadTrack:(CFMTrack *)track
{
    self.currentTrack = track;

    if (!self.player) {
        self.player = [AVPlayer playerWithURL:self.currentTrack.source];
        [self.player addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    } else {
        [self pause];
        [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:self.currentTrack.source]];
    }

    self.loading = YES;
    [self setNowPlayingInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:CFMAudioPlayerDidChangeTrackNotification object:nil];
}

- (void)play
{
    if (!self.currentTrack || self.playing) return;

    self.playing = YES;
    if (self.player.status == AVPlayerStatusReadyToPlay)
        [self startPlaying];
}

- (void)pause
{
    if (!self.currentTrack || !self.playing) return;

    [self.player pause];
    [self setNowPlayingInfoWithPlaybackRate:@0.000001f];
    self.playing = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:CFMAudioPlayerDidPauseNotification object:nil];
}

- (void)stop
{
    [self pause];
}

#pragma mark - Private helpers

- (void)setNowPlayingInfo
{
    if (!self.nowPlayingInfo)
        self.nowPlayingInfo = [NSMutableDictionary dictionary];
    else
        [self.nowPlayingInfo removeAllObjects];

    if (self.currentTrack.name) self.nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentTrack.name;
    if (self.currentTrack.artistName) self.nowPlayingInfo[MPMediaItemPropertyArtist] = self.currentTrack.artistName;

    if (self.currentTrack.albumArtLarge) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.currentTrack.albumArtLarge]]]];
        if (artwork) self.nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork;
    }

    if (self.currentTrack.duration) self.nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.currentTrack.duration;

    [self setNowPlayingInfoWithPlaybackRate:@0];
}

- (void)setNowPlayingInfoWithPlaybackRate:(NSNumber *)rate
{
    if (!self.nowPlayingInfo) return;

    self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate;
    self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime.value / self.player.currentTime.timescale);

    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = self.nowPlayingInfo;
}

- (void)startPlaying
{
    [self.player play];
    [self setNowPlayingInfoWithPlaybackRate:@1];
    [[NSNotificationCenter defaultCenter] postNotificationName:CFMAudioPlayerDidStartPlayingNotification object:nil];
}

#pragma mark - Notification Handlers

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch ([change[NSKeyValueChangeNewKey] integerValue]) {
            case AVPlayerStatusReadyToPlay:
                self.loading = NO;
                if (self.playing)
                    [self startPlaying];
                break;

            case AVPlayerStatusFailed:
                // kill avplayer
                [self.player removeObserver:self forKeyPath:@"status"];
                self.player = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:CFMAudioPlayerDidFinishPlayingNotification object:nil];
                break;

            default:
                break;
        }
    }
}

- (void)audioSessionDidInterrupt:(NSNotification *)notification
{
    NSUInteger type = [notification.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];

    if (type == AVAudioSessionInterruptionTypeBegan) {
        [self.player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:CFMAudioPlayerDidPauseNotification object:nil];
    }
}

- (void)audioSessionDidChangeRoute:(NSNotification *)notification
{
    NSUInteger reason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];

    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        [self.player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:CFMAudioPlayerDidPauseNotification object:nil];
    }
}

#pragma mark - Cleanup

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeObserver:self forKeyPath:@"status"];
}

@end
