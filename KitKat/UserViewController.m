//
//  UserViewController.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/26/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "UserViewController.h"
#import "BackendAPIManager.h"
#import "User.h"
#import "Song.h"
#import "PoolCell.h"
@interface UserViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSMutableArray<Song *>* songs;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getUserSongs];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self getUserSongs];
}

-(void)getUserSongs{
    self.songs = [[BackendAPIManager shared].currentUser fetchUserPool];
    [self.tableView reloadData];
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
    PoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoolCell"];
    [cell setAttributes:self.songs[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

@end
