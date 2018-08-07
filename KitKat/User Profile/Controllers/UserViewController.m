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
#import "UserCell.h"
#import "UserInfoCell.h"
@interface UserViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray<Song *>* songs;
@property (strong, nonatomic) User *currentUser;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
//    [UINavigationController attemptRotationToDeviceOrientation];
    
//    [super viewWillAppear:YES];
//    self.navigationController.navigationBarHidden = NO;
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init]; // pulling up refresh
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
//
//    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self getUserSongs];
}

-(void)getUserSongs{
    [[BackendAPIManager shared] touchUser:[BackendAPIManager shared].currentProtoUser.name withCompletion:^(UNIHTTPJsonResponse *userResponse, NSError *userError) {
        self.currentUser = [[User alloc] initWithDictionary:userResponse.body.object];
        [[BackendAPIManager shared] getSongArray:self.currentUser.songIds withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            self.songs = [Song songsWithArray:response.body.array];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.tableView reloadData];
            });
        }];
    }];
}

- (void)onTimer {
    [self.tableView reloadData];
    
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getUserSongs];
    [[BackendAPIManager shared].currentUser calcScore];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.row ==0){
        UserInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
         [cell setAttributes: self.currentUser];
        return cell;
    }
    else{
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        [cell setAttributes:self.songs[indexPath.row]];
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
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
