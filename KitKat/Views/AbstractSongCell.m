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

    //set artist and album name
    self.artistAlbumLabel.text = [[song.songArtist stringByAppendingString:@" ● "] stringByAppendingString:song.songAlbum];

    //set album cover photo
    self.albumCover.image = nil;
    NSURL *url = [NSURL URLWithString:song.songAlbumArt];
    [self.albumCover setImageWithURL:url];
    
}

-(void)setAddedButton:(Song *)song addedSongs:(NSArray <Song*>*)addedSongs{
    bool isInPool = NO;
    NSString* currUri = song.songUri;
    for(int i = 0; i<addedSongs.count; i++){
        if([addedSongs[i].songUri isEqualToString:currUri]){
            isInPool = YES;
        }
    }
    if(isInPool){
        [self.addCheckButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    }
    else{
        [self.addCheckButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    }
    
}

@end
