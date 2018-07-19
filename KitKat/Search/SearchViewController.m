//
//  SearchViewController.m
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/16/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import <Unirest/UNIRest.h>
#import "SpotifyDataManager.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSArray * searchResults;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;    
    self.searchBar.delegate = self;
}
-(void)fetchSearchResults:(NSString *)query type: (NSString *) type{
    [SpotifyDataManager searchSpotify:query type:type withCompletion:^(NSDictionary *response) {
        if([type isEqualToString:@"artist"]){
            self.searchResults = response[@"artists"][@"items"];
        }
        else if ([type isEqualToString:@"album"]){
            self.searchResults = response[@"albums"][@"items"];
        }
        else if ([type isEqualToString:@"playlist"]){
            self.searchResults = response[@"playlists"][@"items"];
        }
        else if ([type isEqualToString:@"track"]){
            self.searchResults = response[@"tracks"][@"items"];
        }
        [self.tableView reloadData];
    }];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self fetchSearchResults:self.searchBar.text type:@"track"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchCell * searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    NSDictionary * track = self.searchResults[indexPath.row];
    [searchCell setAttributes:track];
    return searchCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
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
