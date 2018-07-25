//
//  SpotifyDataManager.m
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/17/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "SpotifyDataManager.h"
#import "Party.h"

@implementation SpotifyDataManager

+ (instancetype)shared {
    static SpotifyDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+(void)searchSpotify:(NSString *)query type:(NSString *)type withCompletion:(void(^)(NSDictionary *response))completion{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *headers = @{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [defaults objectForKey:@"accessToken"]]};
    NSDictionary *parameters = @{@"q":query,@"type":type};
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://api.spotify.com/v1/search"];
        [request setParameters:parameters];
        [request setHeaders:headers];
    }] asJson];
    completion(response.body.object);
}

-(void)createPlaylist{
    // Creates a playlist for the signed in user with the name of the party
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [SPTPlaylistList createPlaylistWithName:[[BackendAPIManager shared] party].name forUser:[defaults objectForKey:@"username"] publicFlag:YES accessToken:[defaults objectForKey:@"accessToken"] callback:^(NSError *error, SPTPlaylistSnapshot *playlist) {
        if(error){
            NSLog(@"%@",error);
        }
        else{
            NSLog(@"Successfully Initialized a new playlist");
            //save the uri for the playlist in the party object
            self.playlist = playlist;
        }
    }];
}

-(void)addTrackToEndOfPartyPlaylist:(NSString*)trackUri {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *headers = @{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [defaults objectForKey:@"accessToken"]]};
    
    //get user id
    UNIHTTPJsonResponse *userResponse = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://api.spotify.com/v1/me"];
        [request setHeaders:headers];
    }] asJson];
    NSString * userId = userResponse.body.object[@"id"];
    
    //get the playlist's spotify id from the uri
    NSString *uri = [NSString stringWithFormat:@"%@", self.playlist.uri];
    NSArray *items = [uri componentsSeparatedByString:@":"];
    NSString *spotifyId = [items objectAtIndex:4];
    
    //set up url
    NSString * url = @"https://api.spotify.com/v1/users/";
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@/playlists/%@/tracks?uris=%@",userId,spotifyId,trackUri]];
    
    //make post request
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:url];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
        else{
            NSLog(@"%@",response.body.object[@"snapshot_id"]);
        }
    }];
}
@end
