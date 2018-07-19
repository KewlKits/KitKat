//
//  SearchCell.m
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/16/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "SearchCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.albumCover.layer.cornerRadius = self.albumCover.frame.size.width / 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributes:(NSDictionary *)track{
    self.albumCover.layer.cornerRadius = self.albumCover.frame.size.width / 2;
    //set title
    self.songTitleLabel.text = track[@"name"];
    
    //set artist, if there are multiple artists print them all
    NSString * artists = track[@"artists"][0][@"name"];
    for (int i = 1; i< [track[@"artists"] count]; i++){
        artists = [artists stringByAppendingString:@" and "];
        artists = [artists stringByAppendingString:track[@"artists"][i][@"name"]];
    }
    self.artistLabel.text = artists;
    
    //set album name
    self.albumLabel.text = track[@"album"][@"name"];
    
    //set album cover photo
    self.albumCover.image = nil;
    NSURL *url = [NSURL URLWithString:track[@"album"][@"images"][0][@"url"]];
    [self.albumCover setImageWithURL:url];
}
@end
