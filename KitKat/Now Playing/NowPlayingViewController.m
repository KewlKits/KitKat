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
#import <SpotifyMetadata/SpotifyMetadata.h>
#import "SpotifySingleton.h"
#import "BackendAPIManager.h"
#import "Song.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NowPlayingViewController ()
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property NSMutableArray * queue;
@property bool playing;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *skipForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *skipBackButton;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *songImageView;
@property (weak, nonatomic) IBOutlet UIView *playingView;
@property (strong, nonatomic) NSTimer * metadataTimer;

@end

@implementation NowPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.songImageView.layer.cornerRadius = self.songImageView.frame.size.width / 2;
    
    self.playButton.hidden = ![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId];
    self.skipForwardButton.hidden = ![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId];
    self.skipBackButton.hidden = ![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId];

    [self.playingView setHidden:YES];
    
    //if the DJ
    if([[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId]){
        self.playing = YES;
        [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        SpotifySingleton *spotifySingleton = [SpotifySingleton getInstance];
        self.player = [spotifySingleton getPlayer];
        
        // Become the streaming controller delegate
        self.player.delegate = self;
        
        //play the playlist
        NSString *uri = [BackendAPIManager shared].party.playlistUri;
        if(uri != nil){
            [self playUri:uri];
        }
    }
    
    //if not the DJ
    if(![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId]){
        [self notDJRefreshUI];
        //self.metadataTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(notDJRefreshUI:) userInfo:nil repeats:YES];
    }

}
//-(void)notDJRefreshUI:(NSTimer*)timer{
-(void)notDJRefreshUI{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"accessToken"];
    [[BackendAPIManager shared] getAParty:[BackendAPIManager shared].party.partyId withCompletion:^(UNIHTTPJsonResponse * response, NSError *error) {
        if(!error){
            [BackendAPIManager shared].party = [[Party alloc] initWithDictionary: response.body.object];
            [SPTTrack trackWithURI:[NSURL URLWithString:[BackendAPIManager shared].party.nowPlayingId] accessToken:token market:nil callback:^(NSError *err, id object) {
                if(!error){
                    SPTTrack * track = (SPTTrack *) object;
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self.songImageView setImageWithURL:track.album.largestCover.imageURL];
                        self.songTitleLabel.text = track.name;
                        SPTPartialArtist *artist = (SPTPartialArtist *) track.artists[0];
                        self.artistNameLabel.text = artist.name;
                        [self.playingView setHidden:NO];
                        [self notDJRefreshUI];
                    });
                }
            }];
        }
    }];

}
- (IBAction)onPlay:(id)sender {
    if(!self.playing){
        [self.player setIsPlaying:YES callback:nil];
        [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        self.playing = YES;
    }
    else{
        [self.player setIsPlaying:NO callback:nil];
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        self.playing = NO;
    }
    [self updateUI];
}
- (IBAction)onSkip:(id)sender {
    [self.player skipNext:^(NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
        [self updateUI];
    }];
}
- (IBAction)onSkipBack:(id)sender {
    [self.player skipPrevious:^(NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
        [self updateUI];
    }];
}
-(void)updateUI{
    dispatch_async(dispatch_get_main_queue(),^{
        [self.songImageView setImageWithURL:[NSURL URLWithString:self.player.metadata.currentTrack.albumCoverArtURL]];
        self.songTitleLabel.text = self.player.metadata.currentTrack.name;
        self.artistNameLabel.text = self.player.metadata.currentTrack.artistName;
        [self.playingView setHidden:NO];
    });
}

-(void)playUri: (NSString *)spotifyURI{
    __weak typeof (self) weak_self = self;
    __strong typeof (self) strong_self = weak_self;
    [self.player playSpotifyURI:spotifyURI startingWithIndex:0 startingWithPosition:0 callback:^(NSError *error) {
        if (error != nil) {
            NSLog(@"*** failed to play: %@", error);
            return;
        }
        else{
            NSLog(@"Playing Music: %@",spotifyURI);
            if(strong_self){
                [self addObserver:self forKeyPath:@"player.metadata.currentTrack" options:0 context:nil];
                [self updateUI];
            }
        }
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"player.metadata.currentTrack"]) {
        [self updateUI];
        [[BackendAPIManager shared] setNowPlaying:self.player.metadata.currentTrack.uri withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
            if(error){
                NSLog(@"%@",error);
            }
        }];
    }
}

- (void)populateQueue {
    [[BackendAPIManager shared] getAParty:[BackendAPIManager shared].party.partyId withCompletion:^(UNIHTTPJsonResponse * response, NSError * error) {
        if(response){
            self.queue = (NSMutableArray *)[Song songsWithArray:response.body.object[@"queue"]];
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
