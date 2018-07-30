//
//  PartyAnnotation.h
//  KitKat
//
//  Created by Miles Olson on 7/30/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Party.h"

@interface PartyAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) Party *party;
@end


