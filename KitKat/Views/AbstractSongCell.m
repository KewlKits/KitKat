//
//  AbstractSongCell.m
//  KitKat
//
//  Created by Miles Olson on 7/20/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "AbstractSongCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Song.h"
@implementation AbstractSongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributes:(Song *)song{
    self.albumCover.layer.cornerRadius = self.albumCover.frame.size.width / 2;
    self.song = song;
    //set title
    self.songTitleLabel.text = song.songTitle;

    //set artist
    self.artistLabel.text = song.songArtist;

    //set album name
    self.albumLabel.text = song.songAlbum;

    //set album cover photo
    self.albumCover.image = nil;
    NSURL *url = [NSURL URLWithString:song.songAlbumArt];
    [self.albumCover setImageWithURL:url];

    
}
@end
