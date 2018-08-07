//
//  User.h
//  KitKat
//
//  Created by Miles Olson on 7/25/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtoUser.h"
#import "Song.h"
@interface User : ProtoUser
@property (strong, nonatomic) NSArray<NSString *> *partyIds;
@property (strong, nonatomic) NSArray<NSString *> *songIds;
@property (strong, nonatomic) NSArray<NSString *> *upvoteIds;
@property (strong, nonatomic) NSArray<NSString *> *downvoteIds;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (void) calcScore; 

@end
