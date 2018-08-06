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
    self.songAdded = NO;
}


-(void)setVoteAttributes:(Song *)song{
    self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", (long)song.upvotedBy.count - (long)song.downvotedBy.count];
    self.upvoteButton.selected = NO;
    self.downvoteButton.selected = NO;
    if([song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        self.upvoteButton.selected = YES;
    }
    if([song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        self.downvoteButton.selected = YES;
    }
}



- (IBAction)addButtonClicked:(id)sender {
    if(!self.songAdded){
        [[BackendAPIManager shared] moveSongFromPoolToQueue:[BackendAPIManager shared].party.partyId songId:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            if(response){
                [[SpotifyDataManager shared] addTrackToEndOfPartyPlaylist:self.song.songUri];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"songAdded"
                 object:self];
                self.songAdded = YES;
            }
        }];
    }
}

- (IBAction)upvoteButtonClicked:(id)sender {
    if(!self.songAdded){
        long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;
        
        //eliminate existing downvote if you upvote a song
        if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
            self.downvoteButton.selected = NO;
            [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                self.song = [[Song alloc] initWithDictionary:response.body.object];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"voteReorder"
                 object:self];
                
                    }];
            currVoteVal += 1;
        }
        
        
        if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
            self.upvoteButton.selected = NO;
            [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                self.song = [[Song alloc] initWithDictionary:response.body.object];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"voteReorder"
                 object:self];
            }];
            currVoteVal -= 1;
               self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
        }
        
        else{
            self.upvoteButton.selected = YES;
            [[BackendAPIManager shared] upvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                self.song = [[Song alloc] initWithDictionary:response.body.object];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"voteReorder"
                 object:self];
                
            }];
            currVoteVal += 1;
                self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal ];
            
        }
    }
}


- (IBAction)downvoteButtonClicked:(id)sender {
    if(!self.songAdded){
       long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;
        
        //eliminate existing downvote if you upvote a song
        if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
            self.upvoteButton.selected = NO;
            [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                self.song = [[Song alloc] initWithDictionary:response.body.object];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"voteReorder"
                 object:self];
            }];
            currVoteVal -= 1;
        }
        
        if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
            self.downvoteButton.selected = NO;
            [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                self.song = [[Song alloc] initWithDictionary:response.body.object];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"voteReorder"
                 object:self];
            }];
            currVoteVal += 1;
            self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
        }
        
        else{
            self.downvoteButton.selected = YES;
            [[BackendAPIManager shared] downvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                self.song = [[Song alloc] initWithDictionary:response.body.object];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"voteReorder"
                 object:self];
            }];
            currVoteVal -= 1;
            self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
