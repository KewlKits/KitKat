//
//  EntryMapViewController.m
//  KitKat
//
//  Created by Miles Olson on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "EntryMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BackendAPIManager.h"
#import "PartyAnnotation.h"
#import "PartyDetailViewController.h"

@interface EntryMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation EntryMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager requestLocation];
    CLLocation *currentLocation = [self.locationManager location];
    NSLog(@"Location: %@", currentLocation);
    
    MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:sfRegion animated:false];
    
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse *response, NSError *error) {
        for (NSDictionary *dict in response.body.array) {
            PartyAnnotation *pin = [PartyAnnotation new];
            pin.party = [[Party alloc] initWithDictionary:dict];
            pin.coordinate = CLLocationCoordinate2DMake([pin.party.location[1] doubleValue], [pin.party.location[0] doubleValue]);
            [self.mapView addAnnotation:pin];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location update failed: %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"location logged");
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if([control isKindOfClass:[UIButton class]]) {
        [self performSegueWithIdentifier:@"toPartyDetailView" sender:view];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender isKindOfClass:[MKAnnotationView class]]) {
        PartyDetailViewController *partyDetailViewController = (PartyDetailViewController *)[segue destinationViewController];
        partyDetailViewController.party = ((PartyAnnotation *)((MKAnnotationView *)sender).annotation).party;
    }
}


@end
