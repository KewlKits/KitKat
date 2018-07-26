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
    
    return self;
}

- (NSMutableArray<Song *> *)fetchPool {
    NSMutableArray<Song *> *poolSongs = [NSMutableArray arrayWithCapacity:self.pool.count];
    for (int i = 0; i < self.pool.count; i += 1) {
        poolSongs[i] = [[BackendAPIManager shared] getASongSync:self.pool[i] withCompletion:nil];
    }
    
    return poolSongs;
}

- (NSMutableArray<Song *> *)fetchQueue {
    NSMutableArray *queueSongs = [NSMutableArray arrayWithCapacity:self.queue.count];
    for (int i = 0; i < self.queue.count; i += 1) {
        queueSongs[i] = [[BackendAPIManager shared] getASongSync:self.queue[i] withCompletion:nil];
    }
    
    return queueSongs;
}

@end
