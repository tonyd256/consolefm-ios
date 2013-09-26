//
//  CFMTrackCell.h
//  Console.fm
//
//  Created by Tony DiPasquale on 9/26/13.
//  Copyright (c) 2013 Simple Casual. All rights reserved.
//

@interface CFMTrackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArt;

@end
