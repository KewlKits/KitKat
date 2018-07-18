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

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray * searchResults;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [SpotifyDataManager searchSpotify:@"Bound 2" withCompletion:^(NSDictionary *response) {
        NSLog(@"%@", response);
    }];
}

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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchCell * searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    //searchCell.songTitleLabel =
    return searchCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

@end
