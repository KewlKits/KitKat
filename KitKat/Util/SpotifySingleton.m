//
//  SpotifySingleton.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/23/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "SpotifySingleton.h"

@implementation SpotifySingleton

static SpotifySingleton *spotifySingletonInstance;

+(SpotifySingleton*)getInstance{
    if(spotifySingletonInstance == nil){
        spotifySingletonInstance = [[super alloc] init];
    }
    return spotifySingletonInstance;
}

/*-(void)setAuth: (SPTAuth *)authentication{
    _auth = authentication;
}
-(NSString*) getAccessToken{
    return _auth.session.accessToken;
}
-(NSString*) getUsername{
    return _auth.session.canonicalUsername;
}*/

-(void)setPlayer: (SPTAudioStreamingController*)audioPlayer{
    _player = audioPlayer;
}
-(SPTAudioStreamingController*)getPlayer{
    return _player;
}
@end
