//
//  Song.m
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "Song.h"

@implementation Song

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.songTitle = dictionary[@"songTitle"];
    self.songURI = dictionary[@"songURI"];
    self.songArtist = dictionary[@"songArtist"];
    self.songAlbum = dictionary[@"songAlbum"];
    self.songAlbumArt = dictionary[@"songAlbumArt"];

    self.songID = dictionary[@"songIdentity"];
    self.createdAt = dictionary[@"songCreatedAt"];
    
    return self;
}

@end
