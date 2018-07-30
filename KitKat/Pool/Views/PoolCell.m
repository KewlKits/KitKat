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
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//     //   NSLog(@"Do some work");
//           [self setVoteColors];
//    });
    
   // [self setVoteColors];
}


-(void)setVoteAttributes:(Song *)song{
        //NSLog(@"upvoted by: %@", song.upvotedBy);
     self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", (long)song.upvotedBy.count - (long)song.downvotedBy.count];
    if([song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.upvoteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
       // self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", (long)song.upvotedBy.count - (long)song.downvotedBy.count];
    }
    if([song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.downvoteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
      //  self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", (long)song.upvotedBy.count - (long)song.downvotedBy.count];
    }
}

//NSString *stuff = [NSString stringWithFormat:@"%ld", (long)song.upvotedBy.count - (long)song.downvotedBy.count];
//NSLog(@"LOOK HERE");
//NSLog(@"%@", song.songTitle);
//NSLog(@"%@", stuff);

- (IBAction)addButtonClicked:(id)sender {
    [[BackendAPIManager shared] moveSongFromPoolToQueue:[BackendAPIManager shared].party.partyId songId:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        if(response){
            [[SpotifyDataManager shared] addTrackToEndOfPartyPlaylist:self.song.songUri];
        }
    }];
}

- (IBAction)upvoteButtonClicked:(id)sender {
    long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;
    //eliminate any downvote if you upvote a song
    if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.downvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
          //  NSLog(@"un-disliked in order to like");
            self.song = [[Song alloc] initWithDictionary:response.body.object];
                }];
        currVoteVal += 1;
        //self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
    }
    
    if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.upvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // NSLog(@"BELOW upvoted by: %@", self.song.upvotedBy);
        [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
         //   NSLog(@"green to black");
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal -= 1;
           self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
    }
    
    else{
         [self.upvoteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] upvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
         //   NSLog(@"black to green");
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal += 1;
            self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal ];
        
    }
    
}


- (IBAction)downvoteButtonClicked:(id)sender {
   long currVoteVal = (long)self.song.upvotedBy.count - (long)self.song.downvotedBy.count;
    if([self.song.upvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.upvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] unUpvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        //    NSLog(@"un-liked in order to dislike");
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal -= 1;
        //self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
    }
    
    if([self.song.downvotedBy containsObject: [BackendAPIManager shared].currentUser.userId]){
        [self.downvoteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] unDownvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        //    NSLog(@"red to black");
            self.song = [[Song alloc] initWithDictionary:response.body.object];
        }];
        currVoteVal += 1;
        self.songVotesLabel.text = [NSString stringWithFormat:@"%ld", currVoteVal];
    }
    
    else{
        [self.downvoteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [[BackendAPIManager shared] downvote:self.song.songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
       //     NSLog(@"black to red");
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
