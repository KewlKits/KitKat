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
    self.moveToQueueButton.hidden = ![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId];
}


-(void)setVoteAttributes:(Song *)song{
     self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", (long)song.upvotedBy.count - (long)song.downvotedBy.count];
    [self.upvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.downvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if([song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.upvoteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];

    }
    if([song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.downvoteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    }
}



- (IBAction)addButtonClicked:(id)sender {
    [[BackendAPIManager shared] moveSongFromPoolToQueue:[BackendAPIManager shared].party.partyId songId:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        if(response){
            [[SpotifyDataManager shared] addTrackToEndOfPartyPlaylist:self.song.songUri];
        }
    }];
    [self.moveToQueueButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
}

- (IBAction)upvoteButtonClicked:(id)sender {
    long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;
    
    //eliminate existing downvote if you upvote a song
    if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.downvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
                }];
        currVoteVal += 1;
    }
    
    
    if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.upvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal -= 1;
           self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
    }
    
    else{
         [self.upvoteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] upvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal += 1;
            self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal ];
        
    }
    
}


- (IBAction)downvoteButtonClicked:(id)sender {
   long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;
    
    //eliminate existing downvote if you upvote a song
    if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.upvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal -= 1;
    }
    
    if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.downvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal += 1;
        self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
    }
    
    else{
        [self.downvoteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] downvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal -= 1;
        self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
