//
//  BeThePartyViewController.m
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "BeThePartyViewController.h"
#import "Party.h"
#import "BackendAPIManager.h"
#import "JoinPartyViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface BeThePartyViewController ()

@end

@implementation BeThePartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationMan = [CLLocationManager new];
    self.locationMan.delegate = self;
    [self.locationMan requestWhenInUseAuthorization];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)createPartyButtonPressed:(id)sender {
    NSString *partyName = self.textField.text;
    
//    [self.locationMan startUpdatingLocation];
//    [self.locationMan requestLocation];
//    NSLog(@"%@", [self.locationMan location]);
    
    [self.locationMan requestLocation];
    self.thisPartyLoc = [self.locationMan location];
    NSLog(@"%@", [self.locationMan location]);
    NSNumber *partyLong = [NSNumber numberWithDouble: self.thisPartyLoc.coordinate.longitude];
    NSNumber *partyLat = [NSNumber numberWithDouble: self.thisPartyLoc.coordinate.latitude];
    NSLog(@"LONGITUDE %@", partyLong);
   NSLog(@"LATITUDE %@", partyLat);
   // [[BackendAPIManager shared] makeParty:partyName longitude:@(-122.16) latitude:@(37.48) withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
     [[BackendAPIManager shared] makeParty:partyName longitude:partyLong latitude:partyLat withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        Party *party =  [[Party alloc] initWithDictionary: response.body.object];
        [BackendAPIManager shared].party = party;
    }];
    
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location update failed: %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"location logged");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 JoinPartyViewController *joinPartyVC = [segue destinationViewController];
    // in here, pass a selected object; if we are pulling a list of parties do we need to?
}

*/

@end
