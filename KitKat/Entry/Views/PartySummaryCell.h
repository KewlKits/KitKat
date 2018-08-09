//
//  PartySummaryCell.h
//  KitKat
//
//  Created by Natalie Ghidali on 8/8/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Party.h"
@interface PartySummaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

@property (weak, nonatomic) IBOutlet UIImageView *albumArtTopLeft;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtTopRight;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtBottomLeft;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtBottomRight;
-(void)setAttributes: (Party *) party;
@property (strong, nonatomic) Party *party;
@property (strong, nonatomic) NSArray<Song *> *queue;
@end
