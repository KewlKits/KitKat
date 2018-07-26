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
    [[BackendAPIManager shared] moveSongFromPoolToQueue:[BackendAPIManager shared].party.partyId songId:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
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
