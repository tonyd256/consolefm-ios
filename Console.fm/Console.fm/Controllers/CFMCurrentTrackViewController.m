//
//  CFMCurrentTrackViewController.m
//  Console.fm
//
//  Created by Tony DiPasquale on 10/21/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMCurrentTrackViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TDAudioPlayer.h"
#import "TDPlaylist.h"
#import "TDTrack.h"

@interface CFMCurrentTrackViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@end

@implementation CFMCurrentTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.pauseButton setHidden:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidChangeTrack:) name:TDAudioPlayerDidChangeTracksNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    if (![TDAudioPlayer sharedAudioPlayer].loadedPlaylist) {
        NSData *playlistData = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"];

        if (playlistData) {
            TDPlaylist *playlist = (TDPlaylist *)[NSKeyedUnarchiver unarchiveObjectWithData:playlistData];
            [[TDAudioPlayer sharedAudioPlayer] loadPlaylist:playlist];
            [self.playButton setHidden:NO];
            [self.pauseButton setHidden:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[TDAudioPlayer sharedAudioPlayer].loadedPlaylist] forKey:@"savedPlaylist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
            [[TDAudioPlayer sharedAudioPlayer] pause];
            [[TDAudioPlayer sharedAudioPlayer] play];
            [self.playButton setHidden:NO];
            [self.pauseButton setHidden:YES];
            break;

        case UIEventSubtypeRemoteControlPlay:
            [[TDAudioPlayer sharedAudioPlayer] play];
            [self.playButton setHidden:YES];
            [self.pauseButton setHidden:NO];
            break;

        case UIEventSubtypeRemoteControlStop:
            [[TDAudioPlayer sharedAudioPlayer] stop];
            [[TDAudioPlayer sharedAudioPlayer] play];
            [self.playButton setHidden:NO];
            [self.pauseButton setHidden:YES];
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
    TDTrack *track = [TDAudioPlayer sharedAudioPlayer].currentTrack;

    self.titleLabel.text = track.title;
    self.subtitleLabel.text = track.artist;
    [self.albumImage setImageWithURL:[NSURL URLWithString:track.albumArtSmall] placeholderImage:[UIImage imageNamed:@"Icon"]];
    [self.playButton setHidden:YES];
    [self.pauseButton setHidden:NO];
}

- (IBAction)play:(id)sender
{
    [[TDAudioPlayer sharedAudioPlayer] play];
    [self.playButton setHidden:YES];
    [self.pauseButton setHidden:NO];
}

- (IBAction)pause:(id)sender
{
    [[TDAudioPlayer sharedAudioPlayer] pause];
    [self.playButton setHidden:NO];
    [self.pauseButton setHidden:YES];
}

@end
