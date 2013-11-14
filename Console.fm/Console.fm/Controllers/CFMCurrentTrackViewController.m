//
//  CFMCurrentTrackViewController.m
//  Console.fm
//
//  Created by Tony DiPasquale on 10/21/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMCurrentTrackViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CFMTrack.h"
#import "CFMPlaylist.h"

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidChangeTrack:) name:TDAudioPlayerDidChangeAudioNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidPause:) name:TDAudioPlayerDidPauseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidPlay:) name:TDAudioPlayerDidPlayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidStop:) name:TDAudioPlayerDidStopNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidStartPlaying:) name:TDAudioStreamDidStartPlayingNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![CFMPlaylist sharedPlaylist].playlist) {
        NSData *playlistData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"];
        NSNumber *currentTrackIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedTrackIndex"];

        if (playlistData) {
            NSArray *playlist = [NSKeyedUnarchiver unarchiveObjectWithData:playlistData];
            [[CFMPlaylist sharedPlaylist] addTracksFromArray:playlist];
            [[CFMPlaylist sharedPlaylist] loadTrackAtIndex:[currentTrackIndex unsignedIntegerValue]];
            [self.bufferingIndicator setHidden:YES];
            [self.playButton setHidden:NO];
            [self.pauseButton setHidden:YES];
        }
    }
}

- (void)audioPlayerDidChangeTrack:(NSNotification *)notification
{
    CFMTrack *track = [CFMPlaylist sharedPlaylist].currentTrack;

    self.titleLabel.text = track.info.title;
    self.subtitleLabel.text = track.info.artist;
    [self.albumImage setImageWithURL:[NSURL URLWithString:track.info.albumArtSmall] placeholderImage:[UIImage imageNamed:@"Icon"]];
    [self.bufferingIndicator setHidden:NO];
    [self.playButton setHidden:YES];
    [self.pauseButton setHidden:YES];

    self.elapsedTime = 0;
    self.elapsedPlayTimeLabel.text = @"0:00";

    if ([track.info.duration intValue] != 0) {
        self.remainingPlayTimeLabel.text = [NSString stringWithFormat:@"-%@", [self stringForSeconds:[track.info.duration unsignedIntegerValue]]];
    } else {
        self.remainingPlayTimeLabel.text = @"";
    }

    self.playTimeProgress.progress = 0;

    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[CFMPlaylist sharedPlaylist].playlist] forKey:@"savedPlaylist"];
    [[NSUserDefaults standardUserDefaults] setObject:@([CFMPlaylist sharedPlaylist].currentTrackIndex) forKey:@"savedTrackIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)audioPlayerDidStartPlaying:(NSNotification *)notification
{
    [self.bufferingIndicator setHidden:YES];
    [self.playButton setHidden:YES];
    [self.pauseButton setHidden:NO];

    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(elapseTime) userInfo:nil repeats:YES];
}

- (void)audioPlayerDidPause:(NSNotification *)notification
{
    [self pause:nil];
}

- (void)audioPlayerDidPlay:(NSNotification *)notification
{
    [self play:nil];
}

- (void)audioPlayerDidStop:(NSNotification *)notification
{
    [self.playButton setHidden:NO];
    [self.pauseButton setHidden:YES];

    [self.playTimer invalidate];
    self.playTimer = nil;
}

- (void)elapseTime
{
    self.elapsedTime++;
    NSUInteger duration = [[CFMPlaylist sharedPlaylist].currentTrack.info.duration unsignedIntegerValue];

    self.elapsedPlayTimeLabel.text = [self stringForSeconds:self.elapsedTime];

    if (duration == 0) return;
    self.playTimeProgress.progress = (float)self.elapsedTime / duration;
    self.remainingPlayTimeLabel.text = [NSString stringWithFormat:@"-%@", [self stringForSeconds:duration - self.elapsedTime]];
}

- (NSString *)stringForSeconds:(NSUInteger)time
{
    NSUInteger minutes = (NSUInteger)floor(time / 60);
    NSUInteger seconds = time % 60;
    return [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
}

- (IBAction)play:(id)sender
{
    if ([TDAudioPlayer sharedAudioPlayer].state != TDAudioPlayerStatePaused) {
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
