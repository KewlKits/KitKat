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

-(void)createPlaylist:(NSString*)partyName withCompletion:(void (^_Nullable)(NSError*, NSString*))completion{
    // Creates a playlist for the signed in user with the name of the party
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [SPTPlaylistList createPlaylistWithName:partyName forUser:[defaults objectForKey:@"username"] publicFlag:YES accessToken:[defaults objectForKey:@"accessToken"] callback:^(NSError *error, SPTPlaylistSnapshot *playlist) {
        if(!error){
            NSLog(@"%@",error);
            NSLog(@"Successfully Initialized a new playlist");
            //save the uri for the playlist in the party object
            NSString* playlistUri = [NSString stringWithFormat:@"%@", playlist.uri];
            self.playlist = playlistUri;
        }
        if(completion){
            completion(error,self.playlist);
        }
    }];
}

-(void)addTrackToEndOfPartyPlaylist:(NSString*)trackUri {
    if(!self.playlist){
        self.playlist = [BackendAPIManager shared].currentProtoParty.playlistUri;
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *headers = @{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [defaults objectForKey:@"accessToken"]]};
    
    //get user id
    UNIHTTPJsonResponse *userResponse = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://api.spotify.com/v1/me"];
        [request setHeaders:headers];
    }] asJson];
    NSString * userId = userResponse.body.object[@"id"];
    
    //get the playlist's spotify id from the uri
    NSString *uri = [NSString stringWithFormat:@"%@", self.playlist];
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

-(void)moveSongWithinPlaylist:(NSString*) playlistId owner:(NSString *)owner index:(NSNumber *) index target:(NSNumber *) target withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://api.spotify.com/v1/users/%@/playlists/%@/tracks", owner, playlistId]];
        [unibodyRequest setHeaders:@{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"range_start": index, @"range_length": @1, @"insert_before": (index < target) ? ([NSNumber numberWithInteger:[target integerValue] + 1]) : target} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (completion) {
            completion(jsonResponse, error);
        }
    }];
}
-(void)removeSongFromPlaylist:(NSString*) playlistId owner:(NSString *)owner uri:(NSString *) uri withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest deleteEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://api.spotify.com/v1/users/%@/playlists/%@/tracks", owner, playlistId]];
        [unibodyRequest setHeaders:@{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]]}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"tracks": @[@{@"uri": uri}]} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (completion) {
            completion(jsonResponse, error);
        }
    }];
}

@end
