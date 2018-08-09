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
        [currentUser calcScore];
        self.rankLabel.text = [NSString stringWithFormat:@"Score: %@", currentUser.score];
        [self numSongsPool];
        [self numSongsQ];
        self.poolNum.text= [NSString stringWithFormat:@"%i", self.numP];
        self.queueNum.text= [NSString stringWithFormat:@"%i", self.numQ];
        self.currentParty.text = [NSString stringWithFormat:@"Partying in: %@",  [[BackendAPIManager shared].currentProtoParty name] ];
        });
    }];
    
    
}

-(void)numSongsPool{
    [self fetchP:^{}];
     }


-(void)numSongsQ{
        [self fetchQ:^{}];
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
    }];
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
    }];

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
