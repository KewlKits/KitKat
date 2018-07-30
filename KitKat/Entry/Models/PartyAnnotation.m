//
//  PartyAnnotation.m
//  KitKat
//
//  Created by Miles Olson on 7/30/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "PartyAnnotation.h"

@implementation PartyAnnotation

- (NSString *)title {
    return [NSString stringWithFormat:@"%@", self.party.name];
}
@end
