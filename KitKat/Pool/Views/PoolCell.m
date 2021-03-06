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
    self.moveToQueueButton.hidden = ![[BackendAPIManager shared].currentProtoUser.userId isEqualToString:[BackendAPIManager shared].currentProtoParty.ownerId];
    self.songAdded = NO;
}


-(void)setVoteAttributes:(Song *)song{
    self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", (long)song.upvotedBy.count - (long)song.downvotedBy.count];
    self.upvoteButton.selected = NO;
    self.downvoteButton.selected = NO;
    if([song.upvotedBy containsObject: [BackendAPIManager shared].currentProtoUser.userId]){
        self.upvoteButton.selected = YES;
    }
    if([song.downvotedBy containsObject: [BackendAPIManager shared].currentProtoUser.userId]){
        self.downvoteButton.selected = YES;
    }
}



- (IBAction)addButtonClicked:(id)sender {
    [[BackendAPIManager shared] moveSongFromPoolToQueue:[BackendAPIManager shared].currentProtoParty.partyId songId:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        if(response){
            [[SpotifyDataManager shared] addTrackToEndOfPartyPlaylist:self.song.songUri];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"songAdded"
             object:self];
        }
    }];
}


- (IBAction)upvoteButtonClicked:(id)sender {
    
    long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;

    // revert a down to up
    if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentProtoUser.userId]){
        self.downvoteButton.selected = NO;
        [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"voteReorder"
             object:self];
            
                }];
        currVoteVal += 1;
      //  NSLog(@"WE REACHED HERE ");
        
        [[BackendAPIManager shared] getAUser:self.song.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error ) {
            User *thisUser = [[User alloc] initWithDictionary:response.body.object];
            long val = [thisUser.score longValue];
            NSNumber *sum = [NSNumber numberWithLong: val + 1 ];
            [[BackendAPIManager shared] updateScore: self.song.ownerId score: sum withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            }];
        }];
    }
    
    // unlike
     if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentProtoUser.userId]){
        self.upvoteButton.selected = NO;
        [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"voteReorder"
             object:self];
        }];
        currVoteVal -= 1;
           self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
        
        [[BackendAPIManager shared] getAUser:self.song.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error ) {
            User *thisUser = [[User alloc] initWithDictionary:response.body.object];
            long val = [thisUser.score longValue];
            NSNumber *sum = [NSNumber numberWithLong: val - 1 ];
            [[BackendAPIManager shared] updateScore: self.song.ownerId score: sum withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
             //   NSLog(@"WE ARE CHANGING %@", self.song.ownerId);
            }];
            
        }];
        
    }
    
    // new like
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
        
        [[BackendAPIManager shared] getAUser:self.song.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error ) {
            User *thisUser = [[User alloc] initWithDictionary:response.body.object];
            long val = [thisUser.score longValue];
            NSNumber *sum = [NSNumber numberWithLong: val + 1 ];
            [[BackendAPIManager shared] updateScore: self.song.ownerId score: sum withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                //   NSLog(@"WE ARE CHANGING %@", self.song.ownerId);
            }];
            
        }];
    }
    

    
}


- (IBAction)downvoteButtonClicked:(id)sender {
   long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;
    
    //eliminate existing downvote if you upvote a song
    if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentProtoUser.userId]){
        self.upvoteButton.selected = NO;
        [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"voteReorder"
             object:self];
        }];
        currVoteVal -= 1;
        
        [[BackendAPIManager shared] getAUser:self.song.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error ) {
            User *thisUser = [[User alloc] initWithDictionary:response.body.object];
            long val = [thisUser.score longValue];
            NSNumber *sum = [NSNumber numberWithLong: val - 1 ];
            [[BackendAPIManager shared] updateScore: self.song.ownerId score: sum withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                //   NSLog(@"WE ARE CHANGING %@", self.song.ownerId);
            }];
            
        }];
    }
    
    
    // undownvote
    if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentProtoUser.userId]){
        self.downvoteButton.selected = NO;
        [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.song = [[Song alloc] initWithDictionary:response.body.object];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"voteReorder"
             object:self];
        }];
        currVoteVal += 1;
        self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
        
        [[BackendAPIManager shared] getAUser:self.song.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error ) {
            User *thisUser = [[User alloc] initWithDictionary:response.body.object];
            long val = [thisUser.score longValue];
            NSNumber *sum = [NSNumber numberWithLong: val + 1 ];
            [[BackendAPIManager shared] updateScore: self.song.ownerId score: sum withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                //   NSLog(@"WE ARE CHANGING %@", self.song.ownerId);
            }];
            
        }];
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
        
        [[BackendAPIManager shared] getAUser:self.song.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error ) {
            User *thisUser = [[User alloc] initWithDictionary:response.body.object];
            long val = [thisUser.score longValue];
            NSNumber *sum = [NSNumber numberWithLong: val - 1 ];
            [[BackendAPIManager shared] updateScore: self.song.ownerId score: sum withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                //   NSLog(@"WE ARE CHANGING %@", self.song.ownerId);
            }];
            
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
