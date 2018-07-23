//
//  JoinPartyViewController.h
//  KitKat
//
//  Created by Leah Xiao on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Party.h"
#import "PartyCell.h"
#import <CoreLocation/CoreLocation.h>

@interface JoinPartyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) CLLocationManager *locationMan;
@property (strong, nonatomic) CLLocation *thisSessLoc;

@end
