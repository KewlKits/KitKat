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
@property (strong,nonatomic) SPTPlaylistSnapshot * playlist;
+(void)searchSpotify:(NSString *)query type:(NSString *)type withCompletion:(void(^)(NSDictionary *response))completion;
-(void)createPlaylist;
-(void)addTrackToEndOfPartyPlaylist:(NSString*)trackUri;
@end
