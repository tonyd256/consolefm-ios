//
//  CFMTrackViewController.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/24/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMTrackViewController.h"
#import "CFMGenre.h"
#import "CFMTrack.h"
#import "CFMAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "CFMTrackCell.h"
#import "CFMPlaylist.h"

@interface CFMTrackViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tracks;

@end

@implementation CFMTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:self.genre.name];

    [[CFMAPIClient sharedClient] fetchTracksForGenre:self.genre.objectID completion:^(NSError *error, NSArray *tracks) {
        if (!error) {
            self.tracks = tracks;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMTrackCell" forIndexPath:indexPath];

    CFMTrack *track = self.tracks[indexPath.row];
    cell.titleLabel.text = track.name;
    cell.subtitleLabel.text = track.artistName;
    [cell.albumArt setImageWithURL:[NSURL URLWithString:track.albumArtSmall] placeholderImage:[UIImage imageNamed:@"Icon"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[CFMAudioPlayer sharedAudioPlayer] isPlaying]) {
        [[CFMAudioPlayer sharedAudioPlayer] stop];
    }

    [[CFMPlaylist sharedPlaylist] removeAllTracks];
    [[CFMPlaylist sharedPlaylist] addTracksFromArray:[self.tracks copy]];
    [[CFMPlaylist sharedPlaylist] loadTrackAtIndex:indexPath.row];
    [[CFMAudioPlayer sharedAudioPlayer] play];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
