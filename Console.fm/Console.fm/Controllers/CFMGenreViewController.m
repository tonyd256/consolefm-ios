//
//  CFMGenreViewController.m
//  Console.fm
//
//  Created by Tony DiPasquale on 9/24/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMGenreViewController.h"
#import "CFMGenre.h"
#import "CFMAPIClient.h"
#import "CFMTrackViewController.h"

@interface CFMGenreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *genres;

@end

@implementation CFMGenreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[CFMAPIClient sharedClient] fetchGenresWithCompletion:^(NSError *error, NSArray *genres) {
        if (!error) {
            CFMGenre *topGenre = [[CFMGenre alloc] initWithJSON:@{@"name": @"Top Tracks",
                                                                  @"id": @24,
                                                                  @"slug": @"top"}];
            NSMutableArray *genresArray = [NSMutableArray array];
            [genresArray addObject:topGenre];
            [genresArray addObjectsFromArray:genres];
            self.genres = [genresArray copy];
            [self.tableView reloadData];

            [self performSelector:@selector(openMainGenre) withObject:nil afterDelay:1.0];
        }
    }];
}

- (void)openMainGenre
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"]) {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.genres.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFMGenreCell" forIndexPath:indexPath];

    CFMGenre *genre = self.genres[indexPath.row];
    cell.textLabel.text = genre.name;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CFMGenreToTrackSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CFMGenreToTrackSegue"]) {
        CFMTrackViewController *view = [segue destinationViewController];
        view.genre = self.genres[self.tableView.indexPathForSelectedRow.row];
    }
}

@end
