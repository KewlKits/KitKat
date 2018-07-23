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
@property (nonatomic, strong) NSArray<Song *> *pool;
@property (nonatomic, strong) NSArray<Song *> *queue;
@property (nonatomic, strong) NSDate *createdAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
