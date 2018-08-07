//
//  ProtoUser.h
//  KitKat
//
//  Created by Miles Olson on 8/6/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtoUser : NSObject
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *score;

- (id)initWithDictionary:(NSDictionary *) dictionary;
@end
