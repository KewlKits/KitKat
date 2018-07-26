//
//  PoolCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "PoolCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BackendAPIManager.h"
#import "SpotifyDataManager.h"

@implementation PoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)addButtonClicked:(id)sender {
    [[BackendAPIManager shared] addSongToQueue:[BackendAPIManager shared].party.partyId uri:self.song.songUri title:self.song.songTitle artist:self.song.songArtist album:self.song.songAlbum albumArtUrlString:self.song.songAlbumArt withCompletion:^(UNIHTTPJsonResponse * response, NSError * error) {
        if(response){
            [[SpotifyDataManager shared] addTrackToEndOfPartyPlaylist:self.song.songUri];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
