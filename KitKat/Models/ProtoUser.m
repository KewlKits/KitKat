//
//  ProtoUser.m
//  KitKat
//
//  Created by Miles Olson on 8/6/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "ProtoUser.h"

@implementation ProtoUser
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.userId = dictionary[@"_id"];
    self.name = dictionary[@"name"];
    self.score = dictionary[@"score"];
    
    return self;
}
@end
