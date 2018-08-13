//
//  UserInfoCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "UserInfoCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BackendAPIManager.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
  //  NSString *thisID = [[BackendAPIManager shared].currentProtoParty partyId];
//    [[BackendAPIManager shared] getAParty: thisID withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
//        self.party = [[Party alloc] initWithDictionary:response.body.object];
//
//    }];
     [self fetchParty:^{}];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributes:(User*) currentUser{
    [self fetchParty:^{
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.usernameLabel.text = currentUser.name;
            [self.profileImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.adorable.io/avatars/285/%@.png", currentUser.name]]];
            [currentUser calcScore];
            self.rankLabel.text = [NSString stringWithFormat:@"Score: %@", currentUser.score];
            [self fetchP:^{}];
            [self fetchQ:^{}];
            self.currentParty.text = [NSString stringWithFormat:@"Partying in: %@",  [[BackendAPIManager shared].currentProtoParty name]];
        });
    }];
}


-(void)fetchP:(void (^_Nullable)(void))completion {
    [[BackendAPIManager shared] getSongArray:self.party.pool withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        self.numP = 0;
        self.pool = [Song songsWithArray:response.body.array];
        for(int i = 0; i < self.pool.count; i++){
            if([self.pool[i].ownerId isEqualToString: [BackendAPIManager shared].currentProtoUser.userId]){

                self.numP += 1;
            }
            if(completion) {
                completion();
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.poolNum.text= [NSString stringWithFormat:@"%i", self.numP];
        });
        
    }];
    self.poolNum.text= [NSString stringWithFormat:@"%i", self.numP];
}

-(void)fetchQ:(void (^_Nullable)(void))completion {
    [[BackendAPIManager shared] getSongArray:self.party.queue withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        self.numQ = 0;
        self.queue = [Song songsWithArray:response.body.array];
        for(int i = 0; i < self.queue.count; i++){
            if([self.queue[i].ownerId isEqualToString: [BackendAPIManager shared].currentProtoUser.userId]){
                self.numQ += 1;
            }
            if(completion) {
                completion();
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.queueNum.text= [NSString stringWithFormat:@"%i", self.numQ];
        });
        
    }];
     self.queueNum.text= [NSString stringWithFormat:@"%i", self.numQ];

}


-(void)fetchParty:(void (^_Nullable)(void))completion{
    [[BackendAPIManager shared] getAParty:[BackendAPIManager shared].currentProtoParty.partyId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        self.party = [[Party alloc] initWithDictionary:response.body.object];
        if(completion) {
            completion();
        }
    }];
}

@end
