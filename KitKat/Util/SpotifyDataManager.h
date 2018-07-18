//
//  SpotifyDataManager.h
//  SpotifyTest
//
//  Created by Natalie Ghidali on 7/17/18.
//  Copyright © 2018 Natalie Ghidali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotifyDataManager : NSObject
+(void)searchSpotify:query withCompletion:(void(^)(NSDictionary *response))completion;

@end
