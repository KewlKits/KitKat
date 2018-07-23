//
//  SpotifySingleton.h
//  KitKat
//
//  Created by Natalie Ghidali on 7/23/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>

@interface SpotifySingleton : NSObject

@property (nonatomic) SPTAuth *auth;
@property (nonatomic) SPTAudioStreamingController *player;

+(SpotifySingleton*)getInstance;

-(void)setPlayer: (SPTAudioStreamingController*)player;
-(SPTAudioStreamingController*)getPlayer;

-(void)setAuth: (SPTAuth *)auth;
-(NSString*) getAccessToken;
@end
