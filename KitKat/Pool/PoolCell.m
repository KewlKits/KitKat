//
//  PoolCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "PoolCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation PoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributes:(NSDictionary *)track{
    self.albumCover.layer.cornerRadius = self.albumCover.frame.size.width / 2;
    //set title
    self.songTitleLabel.text = track[@"title"];
    
    //set artist
    self.artistLabel.text = track[@"artist"];
    
    //set album name
    self.albumLabel.text = track[@"album"];
    
    //set album cover photo
    self.albumCover.image = nil;
    NSURL *url = [NSURL URLWithString:track[@"uri"]];
    [self.albumCover setImageWithURL:url];
}
@end
