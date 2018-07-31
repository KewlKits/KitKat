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
#import "SpotifyDataManager.h"
#import "SearchCell.h"

@interface PoolViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSArray<Song*> * songs;
@property bool searching;
@end

@implementation PoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    [self populatePool];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; // pulling up refresh
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];

    

    self.searching = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partyLoaded:) name:@"partyLoaded" object:nil];
    //[self populatePool];
}


-(void)partyLoaded:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"partyLoaded"]){
        NSLog (@"party loaded!!");
        [self populatePool];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    self.searching = NO;
    [self populatePool];
}

-(void)populatePool{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool isAgeOn = [defaults boolForKey:@"isAgeOn" ];
    
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse * response, NSError * error) {
        if(response){
            [[BackendAPIManager shared] getAParty:[BackendAPIManager shared].party.partyId withCompletion:^(UNIHTTPJsonResponse * response, NSError * error) {
                
                if(response){

                    if(isAgeOn){
                        self.songs = [[[BackendAPIManager shared].party fetchPool] sortedArrayUsingComparator:^NSComparisonResult(Song* obj1, Song* obj2) {
                            NSDate *d1 = obj1.createdAt;
                            NSDate *d2 = obj2.createdAt;
                            NSComparisonResult result = [d1 compare:d2];
                            return result;
                        }];
                    }
                    
                    else{
                        self.songs = [[[BackendAPIManager shared].party fetchPool] sortedArrayUsingComparator:^NSComparisonResult(Song* obj1, Song* obj2) {
                            long d1 = (long)obj1.upvotedBy.count - (long) obj1.downvotedBy.count;
                            long d2 = (long) obj2.upvotedBy.count - (long) obj2.downvotedBy.count;
                            if (d1 < d2) {
                                return (NSComparisonResult)NSOrderedDescending;
                            }
                           else if (d1 > d2) {
                                return (NSComparisonResult)NSOrderedAscending;
                            }
                            return (NSComparisonResult)NSOrderedSame;
                        }];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [self.tableView reloadData];
                    });
                }
            }];
        }
    }];
}



-(void)fetchSearchResults:(NSString *)query type: (NSString *) type{
    
    [SpotifyDataManager searchSpotify:query type:type withCompletion:^(NSDictionary *response) {
        NSArray *temporary = [[NSArray alloc] init];
        
        if([type isEqualToString:@"artist"]){
            temporary = response[@"artists"][@"items"];
        }
        else if ([type isEqualToString:@"album"]){
            temporary = response[@"albums"][@"items"];
        }
        else if ([type isEqualToString:@"playlist"]){
            temporary = response[@"playlists"][@"items"];
        }
        else if ([type isEqualToString:@"track"]){
            temporary = response[@"tracks"][@"items"];
        }
        
        self.songs = [SpotifySong songsWithArray:temporary];
        [self.tableView reloadData];
    }];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searching = YES;
    [self fetchSearchResults:self.searchBar.text type:@"track"];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searching = NO;
    self.searchBar.text = @"";
    [self populatePool];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(!self.searching){
        PoolCell * poolCell = [tableView dequeueReusableCellWithIdentifier:@"PoolCell"];
        Song * track = self.songs[indexPath.row];
        [poolCell setAttributes: track];
        [poolCell setVoteAttributes:track];
        return poolCell;
    }
    else{
        SearchCell * searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        Song * track = self.songs[indexPath.row];
        [searchCell setAttributes:track];
        return searchCell;
    }
}


//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    PoolCell * poolCell = [tableView dequeueReusableCellWithIdentifier:@"PoolCell"];
//    Song * track = self.poolSongs[indexPath.row];
//    [poolCell setAttributes: track];
//    [poolCell setVoteAttributes:track];
//    return poolCell;
//}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sorterButtonTapped:(id)sender {
    bool ageOn;
    if([self.sorterButton.title isEqual: @"Filter by popularity"]){
        ageOn = NO;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:ageOn forKey:@"isAgeOn"];
        [self.sorterButton setTintColor:[UIColor whiteColor]];
        [self.sorterButton setTitle:@"Filter by Age"];
        [self populatePool];
         [self.tableView reloadData];
       
        
    }
    else{
        ageOn = YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:ageOn forKey:@"isAgeOn"];
        [self.sorterButton setTintColor:[UIColor redColor]];
        [self.sorterButton setTitle:@"Filter by popularity"];
        [self populatePool];
        [self.tableView reloadData];
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self populatePool];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}



@end
