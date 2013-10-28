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
#import "CFMArtist.h"
#import "CFMAPIClient.h"
#import "UIImageView+AFNetworking.h"
#import "CFMTrackCell.h"
#import "TDAudioPlayer.h"
#import "TDPlaylist.h"

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
    cell.titleLabel.text = track.title;
    cell.subtitleLabel.text = track.artist;
    [cell.albumArt setImageWithURL:[NSURL URLWithString:track.albumArtSmall] placeholderImage:[UIImage imageNamed:@"Icon"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([TDAudioPlayer sharedAudioPlayer].isPlaying) {
        [[TDAudioPlayer sharedAudioPlayer] stop];
    }

    TDPlaylist *playlist = [[TDPlaylist alloc] init];
    [playlist addTracksFromArray:self.tracks];
    playlist.currentTrackIndex = indexPath.row;
    [[TDAudioPlayer sharedAudioPlayer] loadPlaylist:playlist];

    [[TDAudioPlayer sharedAudioPlayer] play];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
