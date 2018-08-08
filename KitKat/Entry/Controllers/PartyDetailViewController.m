//
//  PartyDetailViewController.m
//  KitKat
//
//  Created by Miles Olson on 7/30/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "PartyDetailViewController.h"
#import "BackendAPIManager.h"
#import "SpotifyDataManager.h"
#import "QueueCell.h"
#import "PartySummaryCell.h"

@interface PartyDetailViewController () <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSArray<Song *> *queue;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[BackendAPIManager shared] getSongArray:self.party.queue withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        self.queue = [Song songsWithArray:response.body.array];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.tableView reloadData];
        });
    }];
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
        [BackendAPIManager shared].currentProtoParty = self.party;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        PartySummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartySummaryCell"];
        [cell setAttributes:self.party];
        return cell;
    }
    else{
        QueueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueueCell"];
        if(self.queue != nil){
            [cell setAttributes:self.queue[indexPath.row]];
        }
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.party.queue.count;
}

@end
