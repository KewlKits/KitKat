//
//  PartyDetailViewController.m
//  KitKat
//
//  Created by Miles Olson on 7/30/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PartyDetailViewController.h"
#import "BackendAPIManager.h"
#import "SpotifyDataManager.h"

@interface PartyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

@end

@implementation PartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = self.party.name;
    
    [[BackendAPIManager shared] getAUser:self.party.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        if (!error) {
            User *owner = [[User alloc] initWithDictionary:response.body.object];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                self.ownerLabel.text = [NSString stringWithFormat:@"Host: %@", owner.name];
            });
        }
    }];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocation *partyLocation = [[CLLocation alloc] initWithLatitude:[self.party.location[1] doubleValue] longitude:[self.party.location[0] doubleValue]];
    
    [geocoder reverseGeocodeLocation:partyLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(!error && placemarks && placemarks.count > 0) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@", placemarks[0].name];
        }
        else {
            self.addressLabel.text = @"Unknown location";
        }
    }];
    
    self.counterLabel.text = [NSString stringWithFormat:@"%lu in pool • %lu in queue", self.party.pool.count, self.party.queue.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[UIButton class]]) {
        [BackendAPIManager shared].party = self.party;
    }
}


@end
