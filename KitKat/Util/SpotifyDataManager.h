//
//  SpotifyDataManager.h
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/17/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackendAPIManager.h"
#import <UNIRest.h>
#import "SpotifySingleton.h"
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <UIKit/UIKit.h>

@interface SpotifyDataManager : NSObject
+ (instancetype)shared;
@property (strong,nonatomic) NSString * playlist;
+(void)searchSpotify:(NSString *)query type:(NSString *)type withCompletion:(void(^)(NSDictionary *response))completion;
-(void)createPlaylist:(NSString*) partyName withCompletion:(void (^_Nullable)(NSError*, NSString*))completion;
-(void)addTrackToEndOfPartyPlaylist:(NSString*)trackUri;
-(void)moveSongWithinPlaylist:(NSString*) playlistId owner:(NSString *)owner index:(NSNumber *) index target:(NSNumber *) target withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
@end
