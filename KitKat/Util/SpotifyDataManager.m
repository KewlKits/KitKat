//
//  SpotifyDataManager.m
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/17/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "SpotifyDataManager.h"

@implementation SpotifyDataManager

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

-(void)addTrackToEndOfPlaylist:(NSString*)uri{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    SPTTrack * track = [self trackFromUri:uri];
    NSArray * trackArray = [NSArray arrayWithObject:track];
    [self.playlist addTracksToPlaylist:trackArray withAccessToken:[defaults objectForKey:@"accessToken"] callback:^(NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }
        else{
            NSLog(@"added track to end of playlist");
        }
    }];
}
-(SPTTrack*)trackFromUri:(NSString*) uri{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString:uri];
    __block SPTTrack * track;
    [SPTTrack trackWithURI:url accessToken:[defaults objectForKey:@"accessToken"] market:nil callback:^(NSError *error, id object) {
        if(error){
            NSLog(@"%@",error);
        }
        else{
            NSLog(@"Successfully retrieved track from uri");
        }
        track = (SPTTrack*) object;
    }];
    return track;
}
@end
