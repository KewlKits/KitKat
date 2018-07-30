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
    
    self.playButton.hidden = ![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId];
    self.skipForwardButton.hidden = ![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId];
    self.skipBackButton.hidden = ![[BackendAPIManager shared].currentUser.userId isEqualToString:[BackendAPIManager shared].party.ownerId];

    [self.playingView setHidden:YES];
    
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
    
    /*if(self.player.metadata.currentTrack){
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.player.metadata.currentTrack.albumCoverArtURL]];
        [self.songImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [self.playingView setHidden:NO];
            self.songImageView.image = image;
            self.songTitleLabel.text = self.player.metadata.currentTrack.name;
            self.artistNameLabel.text = self.player.metadata.currentTrack.artistName;
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }*/
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
                //self.metadataTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
                [self addObserver:self forKeyPath:@"player.metadata.currentTrack" options:0 context:nil];
                [self updateUI];
            }
        }
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"player.metadata.currentTrack"]) {
        [self updateUI];
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
