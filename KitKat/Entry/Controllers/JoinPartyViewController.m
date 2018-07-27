//
//  JoinPartyViewController.m
//  KitKat
//
//  Created by Leah Xiao on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "JoinPartyViewController.h"
#import "BackendAPIManager.h"



@interface JoinPartyViewController ()
@property (strong, nonatomic ) NSArray<Party *> *partyList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JoinPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //get the current session's location and set the location to a location object
    self.locationMan = [CLLocationManager new];
    self.locationMan.delegate = self;
    [self.locationMan requestWhenInUseAuthorization];
    [self.locationMan requestLocation];
    self.thisSessLoc = [self.locationMan location];

    // call the get all parties list.
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *dict in response.body.array) {
            Party *party = [[Party alloc] initWithDictionary:dict];
            double partyLat = [party.location[1] doubleValue];
            double partyLong = [party.location[0] doubleValue];
            CLLocation *thisPartyLoc = [[CLLocation alloc] initWithLatitude:partyLat longitude:partyLong];
            float distanceVal = [self.thisSessLoc distanceFromLocation: thisPartyLoc];
            //get all of the parties within a kilometer radius
            if (distanceVal <= 1000){
                [temp addObject:party];
            }


        }
        self.partyList = temp;
        
    }];
    

    
     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self.tableView reloadData];
}

- (void)onTimer {
    // Add code to be run periodically
     [self.tableView reloadData];
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
    if([sender isKindOfClass:[PartyCell class]]) {
        [BackendAPIManager shared].party = [(PartyCell *)sender party];
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PartyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartyCell" forIndexPath:indexPath];
    [cell setParty: self.partyList[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.partyList.count;
}


- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"location update failed: %@", error);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"location logged");
}
@end
