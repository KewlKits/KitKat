//
//  QueueViewController.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "QueueViewController.h"
#import "Song.h"
#import "BackendAPIManager.h"
#import "QueueCell.h"
#import "SpotifyDataManager.h"

@interface QueueViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic) Party *party;
@property(strong, nonatomic) NSMutableArray<Song *> *queue;
@end

@implementation QueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.editing = false;
    
    if (![[BackendAPIManager shared].currentProtoUser.userId isEqualToString:[BackendAPIManager shared].currentProtoParty.ownerId]) {
        [self.editButton setEnabled:NO];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self fetchParty:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!self.tableView.isEditing) {
                    [self populateQueue];
                }
            });
        }];
    }];
}

-(void)fetchParty:(void (^_Nullable)(void))completion{
    NSLog(@"fetching party from queue");
    [[BackendAPIManager shared] getAParty:[BackendAPIManager shared].currentProtoParty.partyId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        self.party = [[Party alloc] initWithDictionary:response.body.object];
        if(completion) {
            completion();
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onEditTapped:(id)sender {
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    [self.navigationItem.rightBarButtonItem setTitle:(self.tableView.isEditing) ? @"Done" : @"Edit"];
}

- (void)populateQueue {
    [[BackendAPIManager shared] getSongArray:self.party.queue withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSArray *unsortedQueue = [NSMutableArray arrayWithArray:[Song songsWithArray:response.body.array]];
        NSMutableDictionary *queueMap = [NSMutableDictionary new];
        for (Song *song in unsortedQueue) {
            [queueMap setObject:song forKey:song.songId];
        }
        NSMutableArray *queueBuilder = [NSMutableArray new];
        for (NSString *songId in self.party.queue) {
            [queueBuilder addObject:[queueMap objectForKey:songId]];
        }
        self.queue = queueBuilder;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self.tableView reloadData];
        });
    }];
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
    QueueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QueueCell"];
    [cell setAttributes:self.queue[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.queue.count;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [[BackendAPIManager shared] removeSongFromQueue:self.party.partyId songId:self.queue[indexPath.row].songId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            if(!error) {
                NSLog(@"%@", self.queue[indexPath.row].songTitle);
                [[SpotifyDataManager shared] removeSongFromPlaylist:[self.party.playlistUri componentsSeparatedByString:@":"].lastObject owner:[BackendAPIManager shared].currentProtoUser.name uri:self.queue[indexPath.row].songUri withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.queue removeObjectAtIndex:indexPath.row];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    });
                }];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Song *selected = self.queue[sourceIndexPath.row];
    [self.queue removeObject:selected];
    [self.queue insertObject:selected atIndex:destinationIndexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BackendAPIManager shared] moveSongWithinQueue:self.party.partyId index:[NSNumber numberWithUnsignedInteger:sourceIndexPath.row] target:[NSNumber numberWithUnsignedInteger:destinationIndexPath.row] withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            if (!error) {
                [[SpotifyDataManager shared] moveSongWithinPlaylist:[self.party.playlistUri componentsSeparatedByString:@":"].lastObject owner:[BackendAPIManager shared].currentProtoUser.name index:[NSNumber numberWithUnsignedInteger:sourceIndexPath.row] target:[NSNumber numberWithUnsignedInteger:destinationIndexPath.row] withCompletion:nil];
            }
        }];
    });
}

@end
