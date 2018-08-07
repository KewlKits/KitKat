//
//  Party.h
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "ProtoParty.h"

@interface Party : ProtoParty
@property (nonatomic, strong) NSArray<NSString *> *pool;
@property (nonatomic, strong) NSArray<NSString *> *queue;
@property (nonatomic, strong) NSString *nowPlayingId;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
