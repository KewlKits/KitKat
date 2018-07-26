//
//  Song.h
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpotifySong.h"

@interface Song : SpotifySong

@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSString *partyId;
@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSArray<NSString *> *upvotedBy;
@property (nonatomic, strong) NSArray<NSString *> *downvotedBy;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray<Song *> *)songsWithArray:(NSArray *)dicts;
@end
