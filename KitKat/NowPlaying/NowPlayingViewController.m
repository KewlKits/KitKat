//
//  NowPlayingViewController.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/23/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "SpotifyDataManager.h"
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import "SpotifySingleton.h"
#import "BackendAPIManager.h"
#import "Song.h"

@interface NowPlayingViewController ()
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property NSMutableArray * queue;

@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SpotifySingleton *spotifySingleton = [SpotifySingleton getInstance];
    self.player = [spotifySingleton getPlayer];
    
    // Become the streaming controller delegate
    self.player.delegate = self;
    SPTPlaylistSnapshot * playlist = [SpotifyDataManager shared].playlist;
    NSString *uri = [NSString stringWithFormat:@"%@", playlist.uri];
    if(playlist != nil){
        [self playUri:uri];
    }
}

-(void)playUri: (NSString *)spotifyURI{
    [self.player playSpotifyURI:spotifyURI startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to play: %@", error);
            return;
        }
        NSLog(@"Playing Music: %@",spotifyURI);
    }];
}
- (void)populateQueue {
    [[BackendAPIManager shared] getAParty:[BackendAPIManager shared].party.partyId withCompletion:^(UNIHTTPJsonResponse * response, NSError * error) {
        if(response){
            self.queue = (NSMutableArray *)[Song songsWithDatabaseArray:response.body.object[@"queue"]];
        }
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

@end
