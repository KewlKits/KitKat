    //
//  BackendAPIManager.m
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "BackendAPIManager.h"
#import "SpotifyDataManager.h"
@implementation BackendAPIManager

+ (instancetype)shared {
    static BackendAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void)getAllParties:(void (^_Nonnull)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:@"https://kk-backend.herokuapp.com/party/"];
    }] asJsonAsync:completion];
}

- (void)makeParty:(NSString *) partyName longitude:(NSNumber *)longitude latitude: (NSNumber *) latitude withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest postEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party"];
        [unibodyRequest setHeaders: @{@"Content-Type": @"application/json"}];
       [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"name":partyName,@"longitude":longitude, @"latitude":latitude} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
            [SpotifyDataManager createPlaylist];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void) getAParty: (NSString *) partyId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[@"https://kk-backend.herokuapp.com/party/" stringByAppendingString:partyId]];
    }] asJsonAsync:completion];
}

- (void) deleteParty: (NSString *) partyId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    NSString *preURL = [@"https://kk-backend.herokuapp.com/party/" stringByAppendingString:partyId];

    [[UNIRest delete:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:preURL];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)addSongToPool:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/pool/add", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"uri": uri, @"title": title, @"artist": artist, @"album": album, @"albumArtUrl": albumArtUrlString} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void) removeSongFromPool:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party/%@/pool/remove"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void) moveSongFromPoolToQueue:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party/%@/pool"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)addSongToQueue:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/queue/add", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"uri": uri, @"title": title, @"artist": artist, @"album": album, @"albumArtUrl": albumArtUrlString} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void) removeSongFromQueue:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/queue/remove", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void) moveSongWithinQueue:(NSString*) partyId index:(NSNumber*) index target:(NSNumber*) target withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/queue/move", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"index": index, @"target": target} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.party = [[Party alloc] initWithDictionary:jsonResponse.body.object];
        }
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}
@end
