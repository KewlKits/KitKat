//
//  User.m
//  KitKat
//
//  Created by Miles Olson on 7/25/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "User.h"

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
@end
