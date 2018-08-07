    //
//  BackendAPIManager.m
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "BackendAPIManager.h"
#import "SpotifyDataManager.h"
#import "Song.h"
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

- (void)makeParty:(NSString *)partyName longitude:(NSNumber *)longitude latitude: (NSNumber *) latitude playlistUri:(NSString *) playlistUri withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest postEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party"];
        [unibodyRequest setHeaders: @{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"name":partyName, @"longitude":longitude, @"latitude":latitude, @"playlistUri": playlistUri, @"owner":self.currentProtoUser.userId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(!error) {
            self.currentProtoParty = [[ProtoParty alloc] initWithDictionary:jsonResponse.body.object];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"partyLoaded"
             object:self];
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
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)setNowPlaying: (NSString *) songURI withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/now_playing", self.currentProtoParty.partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_uri": songURI} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)addSongToPool:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/pool/add", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"uri": uri, @"title": title, @"artist": artist, @"album": album, @"albumArtUrl": albumArtUrlString, @"owner":self.currentProtoUser.userId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void) removeSongFromPool:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/pool/remove", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void) moveSongFromPoolToQueue:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/pool", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"song_id": songId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)addSongToQueue:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/queue/add", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"uri": uri, @"title": title, @"artist": artist, @"album": album, @"albumArtUrl": albumArtUrlString, @"owner":self.currentProtoUser.userId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
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
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)moveSongWithinQueue:(NSString*) partyId index:(NSNumber*) index target:(NSNumber*) target withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/party/%@/queue/move", partyId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"index": index, @"target": target} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)getAllUsers:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:@"https://kk-backend.herokuapp.com/user"];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)makeUser:(NSString *) name withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest postEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/user"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"name": name} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            self.currentProtoUser = [[ProtoUser alloc] initWithDictionary:jsonResponse.body.object];
        }
        if (completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)touchUser:(NSString *) name withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/user"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"name": name} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            self.currentProtoUser = [[ProtoUser alloc] initWithDictionary:jsonResponse.body.object];
        }
        if (completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)getAUser: (NSString *) userId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[@"https://kk-backend.herokuapp.com/user/" stringByAppendingString:userId]];
    }] asJsonAsync:completion];
}

- (void)getAllSongs:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:@"https://kk-backend.herokuapp.com/song"];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)getASong: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[@"https://kk-backend.herokuapp.com/song/" stringByAppendingString:songId]];
    }] asJsonAsync:completion];
}

-(void) getSongArray: (NSArray<NSString *> *) songIds withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/song/list"];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"songIds": songIds} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)upvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/song/%@/upvote", songId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"user_id": self.currentProtoUser.userId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)unUpvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/song/%@/unupvote", songId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"user_id": self.currentProtoUser.userId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)downvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/song/%@/downvote", songId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"user_id": self.currentProtoUser.userId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)unDownvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/song/%@/undownvote", songId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"user_id": self.currentProtoUser.userId} options:0 error:nil]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

- (void)updateScore: (NSString *) userId score: (NSNumber*) score withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    [[UNIRest putEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:[NSString stringWithFormat:@"https://kk-backend.herokuapp.com/user/%@/score", userId]];
        [unibodyRequest setHeaders:@{@"Content-Type": @"application/json"}];
        [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"score": score} options:0 error:nil]];
    }]asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if(completion) {
            completion(jsonResponse, error);
        }
    }];
}

@end
