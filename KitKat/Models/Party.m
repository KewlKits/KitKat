//
//  Party.m
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "Party.h"
#import "Song.h"

@implementation Party
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.name = dictionary[@"name"];
    self.location = dictionary[@"location"];
    self.pool = [Song songsWithDatabaseArray:dictionary[@"pool"]];
    self.queue = [Song songsWithDatabaseArray:dictionary[@"queue"]];
    
    self.identity = dictionary[@"_id"];
    self.createdAt = dictionary[@"createdAt"];
    
    return self;
}

@end
