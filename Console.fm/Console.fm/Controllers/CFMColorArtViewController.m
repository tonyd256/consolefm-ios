//
//  CFMColorArtViewController.m
//  Console.fm
//
//  Created by Tony DiPasquale on 2/6/14.
//  Copyright (c) 2014 Simple Casual. All rights reserved.
//

#import "CFMColorArtViewController.h"
#import <ColorArt/UIImage+ColorArt.h>
#import "UIImageView+AFNetworking.h"

@interface CFMColorArtViewController ()

@property (weak, nonatomic) IBOutlet UIView *primaryView;
@property (weak, nonatomic) IBOutlet UILabel *primaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *secondaryView;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation CFMColorArtViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:self.imageURL];
    [myRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    __weak typeof(self)weakSelf = self;
    [self.imageView setImageWithURLRequest:myRequest placeholderImage:[UIImage imageNamed:@"Icon"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakSelf.imageView.image = image;
        SLColorArt *colorArt = [image colorArt];
        weakSelf.backgroundView.backgroundColor = colorArt.backgroundColor;
        weakSelf.backgroundView.alpha = 0.5f;
        weakSelf.primaryView.backgroundColor = colorArt.primaryColor;
        weakSelf.secondaryView.backgroundColor = colorArt.secondaryColor;
        weakSelf.primaryLabel.textColor = colorArt.detailColor;
        weakSelf.secondaryLabel.textColor = colorArt.detailColor;
    } failure:nil];
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
