//
//  PoolViewController.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "PoolViewController.h"
#import "PoolCell.h"
#import <Unirest/UNIRest.h>
#import "BackendAPIManager.h"

@interface PoolViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSString * partyId;
@property NSArray * poolSongs;
@end

@implementation PoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.partyId = @"5b50c529c865c50004ae6a35";
    [self populatePool];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self populatePool];
}

-(void)populatePool{
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse * response, NSError * error) {
        if(response){
            //NSLog(@"%@",response);
            [[BackendAPIManager shared] getAParty:self.partyId withCompletion:^(UNIHTTPJsonResponse * response, NSError * error) {
                if(response){
                    NSLog(@"%@",response);
                    self.poolSongs = response.body.object[@"pool"];
                    //[self.tableView reloadData];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self.tableView reloadData];
                    });
                }
            }];
        }
    }];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PoolCell * poolCell = [tableView dequeueReusableCellWithIdentifier:@"PoolCell"];
    NSDictionary * track = self.poolSongs[indexPath.row];
    [poolCell setAttributes: track];
    return poolCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.poolSongs count];
}

/*-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
