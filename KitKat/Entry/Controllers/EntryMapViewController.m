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
#import "SpotifyDataManager.h"

@interface EntryMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UITextField *hostTextField;
@property (weak, nonatomic) IBOutlet UIStackView *hostInputStackView;

@end

@implementation EntryMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsScale = YES;
    self.mapView.showsCompass = YES;
    
    self.hostTextField.delegate = self;
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager requestLocation];
    CLLocation *currentLocation = [self.locationManager location];
    NSLog(@"Location: %@", currentLocation);
    
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse *response, NSError *error) {
        for (NSDictionary *dict in response.body.array) {
            PartyAnnotation *pin = [PartyAnnotation new];
            pin.party = [[Party alloc] initWithDictionary:dict];
            pin.coordinate = CLLocationCoordinate2DMake([pin.party.location[1] doubleValue], [pin.party.location[0] doubleValue]);
            [self.mapView addAnnotation:pin];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView showAnnotations:self.mapView.annotations animated:NO];
            MKCoordinateRegion sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(0.1, 0.1));
            [self.mapView setRegion:sfRegion animated:NO];
        });
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
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    else {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = true;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        return annotationView;
    }
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if([control isKindOfClass:[UIButton class]]) {
        [self performSegueWithIdentifier:@"toPartyDetailView" sender:view];
    }
}

- (IBAction)onCreateButtonTapped:(id)sender {
    [self.locationManager requestLocation];
    CLLocation *currentLocation = [self.locationManager location];
    
    
    [[SpotifyDataManager shared] createPlaylist:self.hostTextField.text withCompletion:^(NSError *error, NSString *uri) {
        [[BackendAPIManager shared] makeParty:self.hostTextField.text longitude:[NSNumber numberWithDouble:currentLocation.coordinate.longitude] latitude:[NSNumber numberWithDouble:currentLocation.coordinate.latitude] playlistUri:uri withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            Party *party =  [[Party alloc] initWithDictionary: response.body.object];
            [BackendAPIManager shared].party = party;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"creationSegue" sender:self.createButton];
            });
        }];
    }];
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(self.hostTextField.isEditing) {
        [UIView animateWithDuration:0.2 animations:^{
            self.hostInputStackView.frame = CGRectMake(self.hostInputStackView.frame.origin.x, self.hostInputStackView.frame.origin.y - 250, self.hostInputStackView.frame.size.width, self.hostInputStackView.frame.size.height);
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        self.hostInputStackView.frame = CGRectMake(self.hostInputStackView.frame.origin.x, self.hostInputStackView.frame.origin.y + 250, self.hostInputStackView.frame.size.width, self.hostInputStackView.frame.size.height);
    }];
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
