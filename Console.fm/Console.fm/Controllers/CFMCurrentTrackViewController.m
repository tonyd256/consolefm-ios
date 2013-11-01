//
//  CFMCurrentTrackViewController.m
//  Console.fm
//
//  Created by Tony DiPasquale on 10/21/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMCurrentTrackViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TDAudioInputStreamer.h"
#import "TDAudioPlayer.h"
#import "CFMTrack.h"

@interface CFMCurrentTrackViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *bufferingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *remainingPlayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *elapsedPlayTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *playTimeProgress;

@property (strong, nonatomic) NSTimer *playTimer;
@property (assign, nonatomic) NSUInteger elapsedTime;

@end

@implementation CFMCurrentTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.pauseButton setHidden:YES];
    [self.playButton setHidden:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidChangeTrack:) name:TDAudioPlayerDidChangeTracksNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidForcePause:) name:TDAudioPlayerDidForcePauseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidStartPlaying:) name:TDAudioInputStreamerDidStartPlayingNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    if (![TDAudioPlayer sharedAudioPlayer].loadedPlaylist) {
        NSData *playlistData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"];
        NSNumber *currentTrackIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedTrackIndex"];

        if (playlistData) {
            NSArray *playlist = [NSKeyedUnarchiver unarchiveObjectWithData:playlistData];
            [[TDAudioPlayer sharedAudioPlayer] loadTrackIndex:[currentTrackIndex unsignedIntegerValue] fromPlaylist:playlist];
            [self.bufferingIndicator setHidden:YES];
            [self.playButton setHidden:NO];
            [self.pauseButton setHidden:YES];
        }
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type != UIEventTypeRemoteControl) return;

    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPause:
            [self pause:nil];
            break;

        case UIEventSubtypeRemoteControlPlay:
            [self play:nil];
            break;

        case UIEventSubtypeRemoteControlStop:
            [[TDAudioPlayer sharedAudioPlayer] stop];
            [self.playButton setHidden:NO];
            [self.pauseButton setHidden:YES];
            [self.playTimer invalidate];
            self.playTimer = nil;
            break;

        case UIEventSubtypeRemoteControlTogglePlayPause:
            if ([[TDAudioPlayer sharedAudioPlayer] isPaused]) {
                [self play:nil];
            } else {
                [self pause:nil];
            }
            break;

        case UIEventSubtypeRemoteControlNextTrack:
            [[TDAudioPlayer sharedAudioPlayer] playNextTrack];
            break;

        case UIEventSubtypeRemoteControlPreviousTrack:
            [[TDAudioPlayer sharedAudioPlayer] playPreviousTrack];
            break;

        default:
            break;
    }
}

- (void)audioPlayerDidChangeTrack:(NSNotification *)notification
{
    CFMTrack *track = (CFMTrack *)[TDAudioPlayer sharedAudioPlayer].currentTrack;

    self.titleLabel.text = track.title;
    self.subtitleLabel.text = track.artist;
    [self.albumImage setImageWithURL:[NSURL URLWithString:track.albumArtSmall] placeholderImage:[UIImage imageNamed:@"Icon"]];
    [self.bufferingIndicator setHidden:NO];
    [self.playButton setHidden:YES];
    [self.pauseButton setHidden:YES];

    self.elapsedTime = 0;
    self.elapsedPlayTimeLabel.text = @"0:00";

    if ([track.duration intValue] != 0) {
        self.remainingPlayTimeLabel.text = [NSString stringWithFormat:@"-%@", [self stringForSeconds:[track.duration unsignedIntegerValue]]];
    } else {
        self.remainingPlayTimeLabel.text = @"";
    }

    self.playTimeProgress.progress = 0;

    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }

    NSUInteger index = [[TDAudioPlayer sharedAudioPlayer].loadedPlaylist indexOfObject:[TDAudioPlayer sharedAudioPlayer].currentTrack];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[TDAudioPlayer sharedAudioPlayer].loadedPlaylist] forKey:@"savedPlaylist"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:index] forKey:@"savedTrackIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)audioPlayerDidStartPlaying:(NSNotification *)notification
{
    [self.bufferingIndicator setHidden:YES];
    [self.playButton setHidden:YES];
    [self.pauseButton setHidden:NO];

    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(elapseTime) userInfo:nil repeats:YES];
}

- (void)audioPlayerDidForcePause:(NSNotification *)notification
{
    [self.playButton setHidden:NO];
    [self.pauseButton setHidden:YES];

    [self.playTimer invalidate];
    self.playTimer = nil;
}

- (void)elapseTime
{
    self.elapsedTime++;
    NSUInteger duration = [[TDAudioPlayer sharedAudioPlayer].currentTrack.duration unsignedIntegerValue];

    self.elapsedPlayTimeLabel.text = [self stringForSeconds:self.elapsedTime];

    if (duration == 0) return;
    self.playTimeProgress.progress = (float)self.elapsedTime / duration;
    self.remainingPlayTimeLabel.text = [NSString stringWithFormat:@"-%@", [self stringForSeconds:duration - self.elapsedTime]];
}

- (NSString *)stringForSeconds:(NSUInteger)time
{
    NSUInteger minutes = (NSUInteger)floor(time / 60);
    NSUInteger seconds = time % 60;
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

- (IBAction)play:(id)sender
{
    if (![[TDAudioPlayer sharedAudioPlayer] isPaused]) {
        [self.bufferingIndicator setHidden:NO];
        [self.playButton setHidden:YES];
        [self.pauseButton setHidden:YES];
    } else {
        [self.playButton setHidden:YES];
        [self.pauseButton setHidden:NO];
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(elapseTime) userInfo:nil repeats:YES];
    }

    [[TDAudioPlayer sharedAudioPlayer] play];
}

- (IBAction)pause:(id)sender
{
    [[TDAudioPlayer sharedAudioPlayer] pause];
    [self.playButton setHidden:NO];
    [self.pauseButton setHidden:YES];

    [self.playTimer invalidate];
    self.playTimer = nil;
}

@end
