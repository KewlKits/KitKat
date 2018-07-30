//
//  PartyDetailViewController.m
//  KitKat
//
//  Created by Miles Olson on 7/30/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "PartyDetailViewController.h"
#import "BackendAPIManager.h"

@interface PartyDetailViewController ()

@end

@implementation PartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
