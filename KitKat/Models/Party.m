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
    self.createdAt = dictionary[@"createdAt"];
    
    self.pool = dictionary[@"pool"];
    self.queue = dictionary[@"queue"];
    self.ownerId = dictionary[@"owner"];
    
    return self;
}

- (NSArray<Song *> *)fetchPool {
    NSMutableArray *poolSongs = [NSMutableArray arrayWithCapacity:self.pool.count];
    for (int i = 0; i < self.pool.count; i += 1) {
        [[BackendAPIManager shared] getASong:self.pool[i] withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            if (!error) {
                poolSongs[i] = [[Song alloc] initWithDictionary:response.body.object];
            }
        }];
    }
    
    return poolSongs;
}

- (NSArray<Song *> *)fetchQueue {
    NSMutableArray *queueSongs = [NSMutableArray arrayWithCapacity:self.pool.count];
    for (int i = 0; i < self.pool.count; i += 1) {
        [[BackendAPIManager shared] getASong:self.queue[i] withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            if (!error) {
                queueSongs[i] = [[Song alloc] initWithDictionary:response.body.object];
            }
        }];
    }
    
    return queueSongs;
}

@end
