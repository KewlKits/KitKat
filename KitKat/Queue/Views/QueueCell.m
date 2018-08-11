//
//  QueueCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "QueueCell.h"

@implementation QueueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributes:(Song *)song nowPlayingId:(NSString *) nowPlayingId {
    [super setAttributes:song];
    if ([song.songUri isEqualToString:nowPlayingId]) {
        [self.songTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
    }
    else {
        [self.songTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
    }
}


@end
