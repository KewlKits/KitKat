//
//  UserInfoCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "UserInfoCell.h"
#import "BackendAPIManager.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributes:(User*) currentUser{
    self.usernameLabel.text = currentUser.name;
 //   self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@", currentUser.name];
    [currentUser calcScore];
    self.rankLabel.text = [NSString stringWithFormat:@"Score: %@", currentUser.score];
        
    //self.poolNum.text= [NSString stringWithFormat:@"%f", [self numSongsPool]];
    //self.queueNum.text= [NSString stringWithFormat:@"%f", [self numSongsQ]];
    self.currentParty.text = [NSString stringWithFormat:@"Partying in: %@",  [[BackendAPIManager shared].currentProtoParty name] ];
    
}
     
//-(float)numSongsPool{
//    __block NSArray <Song*> *songList;
//    __block NSMutableArray <Song*> *usersSongList;
//    //__block long counter;
//    __block float counter;
//    [[BackendAPIManager shared] getSongArray:[BackendAPIManager shared].party.pool withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
//        songList = [Song songsWithArray:response.body.array];
//        for(int i = 0; i < [songList count]; i++){
//            if((songList[i].ownerId == [BackendAPIManager shared].currentUser.userId)){
//                [usersSongList addObject:(songList[i])];
//            }
//        }
//        counter = (float)[usersSongList count];
//        }];
//    NSLog(@"sungs in pool %f", counter);
//    return counter;
//     }
//
//-(float)numSongsQ{
//    __block NSArray <Song*> *songList;
//    __block NSMutableArray <Song*> *usersSongList;
//   // __block long counter;
//    __block float counter;
//    [[BackendAPIManager shared] getSongArray:[BackendAPIManager shared].party.queue withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
//        songList = [Song songsWithArray:response.body.array];
//        for(int i = 0; i < [songList count]; i++){
//            if((songList[i].ownerId == [BackendAPIManager shared].currentUser.userId)){
//                [usersSongList addObject:(songList[i])];
//            }
//        }
//        counter = (float)[usersSongList count];
//    }];
//    NSLog(@"sungs in queue %f", counter);
//    return counter;
//}

@end
