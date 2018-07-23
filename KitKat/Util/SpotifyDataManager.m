//
//  SpotifyDataManager.m
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/17/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import "SpotifyDataManager.h"
#import <UNIRest.h>

@implementation SpotifyDataManager

+(void)searchSpotify:(NSString *)query type:(NSString *)type withCompletion:(void(^)(NSDictionary *response))completion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *headers = @{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [defaults stringForKey:@"accessToken"]]};
    NSDictionary *parameters = @{@"q":query,@"type":type};
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://api.spotify.com/v1/search"];
        [request setParameters:parameters];
        [request setHeaders:headers];
    }] asJson];
    completion(response.body.object);
}

@end
