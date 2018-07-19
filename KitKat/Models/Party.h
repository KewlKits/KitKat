//
//  Party.h
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Party : NSObject
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *location;
@property (nonatomic, strong) NSArray *pool;
@property (nonatomic, strong) NSArray *queue;
@property (nonatomic, strong) NSDate *createdAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
