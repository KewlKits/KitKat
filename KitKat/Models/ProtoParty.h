//
//  ProtoParty.h
//  KitKat
//
//  Created by Miles Olson on 8/6/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtoParty : NSObject
@property (nonatomic, strong) NSString *partyId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray<NSNumber *> *location;
@property (nonatomic, strong) NSString *playlistUri;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *ownerId;

- (id)initWithDictionary:(NSDictionary *) dictionary;
@end
