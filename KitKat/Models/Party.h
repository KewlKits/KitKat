//
//  Party.h
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

@interface Party : NSObject
@property (nonatomic, strong) NSString *partyId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<NSNumber *> *location;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, strong) NSArray<NSString *> *pool;
@property (nonatomic, strong) NSArray<NSString *> *queue;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSArray<Song *> *)fetchPool;
- (NSArray<Song *> *)fetchQueue;
@end
