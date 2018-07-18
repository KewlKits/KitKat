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
    NSLog(@"ACCESS TOKEN IN VIEW DID LOAD: ");
    NSLog(@"%@", [defaults stringForKey:@"accessToken"]);
    NSDictionary *headers = @{@"Accept": @"application/json",@"Content-Type": @"application/json", @"Authorization":[NSString stringWithFormat:@"Bearer %@", [defaults stringForKey:@"accessToken"]]};
    NSDictionary *parameters = @{@"q":query,@"type":type};
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://api.spotify.com/v1/search"];
        [request setParameters:parameters];
        [request setHeaders:headers];
        // Converting NSDictionary to JSON:
    }] asJson];
    //NSLog(@"%@", response.body.object);
    completion(response.body.object);
    //return response.body.object[0];
}

@end
