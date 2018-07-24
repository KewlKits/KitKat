//
//  SpotifyDataManager.m
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/17/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "SpotifyDataManager.h"
#import "BackendAPIManager.h"
#import <UNIRest.h>
#import "SpotifySingleton.h"
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>

@implementation SpotifyDataManager

+(void)searchSpotify:(NSString *)query type:(NSString *)type withCompletion:(void(^)(NSDictionary *response))completion{
    SpotifySingleton *spotifySingleton = [SpotifySingleton getInstance];
    NSDictionary *headers = @{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [spotifySingleton getAccessToken]]};
    NSDictionary *parameters = @{@"q":query,@"type":type};
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://api.spotify.com/v1/search"];
        [request setParameters:parameters];
        [request setHeaders:headers];
    }] asJson];
    completion(response.body.object);
}

+(void)createPlaylist{
    // Creates a playlist for the signed in user with the name of the party
    SpotifySingleton *spotifySingleton = [SpotifySingleton getInstance];
    [SPTPlaylistList createPlaylistWithName:[[BackendAPIManager shared] party].name forUser:[spotifySingleton getUsername] publicFlag:YES accessToken:[spotifySingleton getAccessToken] callback:^(NSError *error, SPTPlaylistSnapshot *playlist) {
        if(error){
            NSLog(@"%@",error);
        }
        else{
            NSLog(@"Successfully Initialized a new playlist");
            //save the uri for the playlist in the party object
        }
    }];
}

+(void)addToPlaylist{
    SpotifySingleton *spotifySingleton = [SpotifySingleton getInstance];
}
@end
