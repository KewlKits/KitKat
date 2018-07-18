//
//  BackendAPIManager.m
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "BackendAPIManager.h"

@implementation BackendAPIManager
+ (void)getAllParties:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        NSLog(@"here");
        [simpleRequest setUrl:@"https://kk-backend.herokuapp.com/party/"];
    }] asJsonAsync:completion];
}

+ (void)addSongToPool:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/pool/add", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"uri": uri, @"title": title, @"artist": artist, @"album": album, @"albumArtUrl": albumArtUrlString} options:0 error:nil]];
    }] asJsonAsync:completion];
}

+ (void) removeSongFromPool:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party/%@/pool/remove"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:completion];
}

+ (void) moveSongFromPoolToQueue:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party/%@/pool"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:completion];
}

+ (void)addSongToQueue:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/queue/add", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"uri": uri, @"title": title, @"artist": artist, @"album": album, @"albumArtUrl": albumArtUrlString} options:0 error:nil]];
    }] asJsonAsync:completion];
}

+ (void) removeSongFromQueue:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party/%@/queue/remove"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:completion];
}

+ (void) moveSongWithinQueue:(NSString*) partyId index:(NSNumber*) index target:(NSNumber*) target withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party/%@/queue/move"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"index": index, @"target": target} options:0 error:nil]];
    }] asJsonAsync:completion];
}
@end
