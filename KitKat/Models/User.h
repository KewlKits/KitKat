//
//  User.h
//  KitKat
//
//  Created by Miles Olson on 7/25/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"
@interface User : NSObject
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *score;

@property (strong, nonatomic) NSArray<NSString *> *partyIds;
@property (strong, nonatomic) NSArray<NSString *> *songIds;
@property (strong, nonatomic) NSArray<NSString *> *upvoteIds;
@property (strong, nonatomic) NSArray<NSString *> *downvoteIds;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableArray<Song *> *)fetchUserPool;
-(void) calcScore;
@end
