//
//  ProtoParty.m
//  KitKat
//
//  Created by Miles Olson on 8/6/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "ProtoParty.h"

@implementation ProtoParty
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.name = dictionary[@"name"];
    self.location = dictionary[@"location"];
    self.partyId = dictionary[@"_id"];
    self.playlistUri = dictionary[@"playlistUri"];
    self.createdAt = dictionary[@"createdAt"];
    self.ownerId = dictionary[@"owner"];

    return self;
}
@end
