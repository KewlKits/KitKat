//
//  User.m
//  KitKat
//
//  Created by Miles Olson on 7/25/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "User.h"
#import "Song.h"
#import "BackendAPIManager.h"

@implementation User
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.userId = dictionary[@"_id"];
    self.name = dictionary[@"name"];
    self.score = dictionary[@"score"];
    
    self.partyIds = dictionary[@"parties"];
    self.songIds = dictionary[@"songs"];
    self.upvoteIds = dictionary[@"upvotes"];
    self.downvoteIds = dictionary[@"downvotes"];
    
    return self;
}

-(void) calcScore{
    __block NSNumber *score = [NSNumber numberWithInt:2];
    __block float floatScore =0;

//    __block NSArray <Song*> *songList;
//    [[BackendAPIManager shared] getSongArray:[BackendAPIManager shared].party.pool withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
//        songList = [Song songsWithArray:response.body.array];
//        for (int i = 0; i < [songList count]; i++)
//        {
//            Song *song = songList[i];
//            floatScore = floatScore +  (float)song.upvotedBy.count - .5 * (float)song.downvotedBy.count;
//            
//        }
//        score = [NSNumber numberWithFloat: floatScore];
//        // NSLog(@" SCORE IS %@", score);
//        [[BackendAPIManager shared] updateScore:[BackendAPIManager shared].currentUser.userId score:score withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
//            NSLog(@"%@", [BackendAPIManager shared].currentUser.score);
//        }];
//    }];
    
}

@end
