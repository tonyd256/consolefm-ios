//
//  CFMMainContainerViewController.m
//  Console.fm
//
//  Created by Tony DiPasquale on 10/28/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

#import "CFMMainContainerViewController.h"
#import "TDAudioInputStreamer.h"

@interface CFMMainContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainContent;
@property (weak, nonatomic) IBOutlet UIView *toolbarContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarContentBottomConstraint;

@property (assign, nonatomic) BOOL toolbarIsVisible;

@end

@implementation CFMMainContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _toolbarIsVisible = YES;

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"savedPlaylist"]) {
        self.toolbarContentBottomConstraint.constant = CGRectGetHeight(self.toolbarContent.frame) * -1;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToolbarContent) name:TDAudioStreamDidStartPlayingNotification object:nil];

        _toolbarIsVisible = NO;
    }
}

- (void)showToolbarContent
{
    self.toolbarContentBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
