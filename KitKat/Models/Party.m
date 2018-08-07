//
//  Party.m
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "Party.h"
#import "BackendAPIManager.h"

@implementation Party
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.name = dictionary[@"name"];
    self.location = dictionary[@"location"];
    self.partyId = dictionary[@"_id"];
    self.playlistUri = dictionary[@"playlistUri"];
    self.createdAt = dictionary[@"createdAt"];
    
    self.pool = dictionary[@"pool"];
    self.queue = dictionary[@"queue"];
    self.ownerId = dictionary[@"owner"];
    self.nowPlayingId = dictionary[@"nowPlaying"];
    
    return self;
}
@end
