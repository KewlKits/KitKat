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

@interface BeThePartyViewController ()

@end

@implementation BeThePartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)createPartyButtonPressed:(id)sender {
    NSString *partyName = self.textField.text;
    [[BackendAPIManager shared] makeParty:partyName longitude:@(-122.16) latitude:@(37.48) withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        Party *party =  [[Party alloc] initWithDictionary: response.body.object];
        NSLog(@"%@", party);
        [BackendAPIManager shared].party = party;
        NSLog(@"%@", [BackendAPIManager shared].party);
    }];
    
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
