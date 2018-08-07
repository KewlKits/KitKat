//
//  SearchCell.m
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/16/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "SearchCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BackendAPIManager.h"
#import "Song.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.albumCover.layer.cornerRadius = self.albumCover.frame.size.width / 2;
    // Initialization code
}
-(void)setAttributes:(Song *)song{
    [super setAttributes:song];
}

- (IBAction)addButtonClicked:(id)sender {
    [[BackendAPIManager shared] addSongToPool:[BackendAPIManager shared].currentProtoParty.partyId uri:self.song.songUri title:self.song.songTitle artist:self.song.songArtist album:self.song.songAlbum albumArtUrlString:self.song.songAlbumArt withCompletion:^(UNIHTTPJsonResponse * response, NSError * error) {
    }];
    [self.addCheckButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
