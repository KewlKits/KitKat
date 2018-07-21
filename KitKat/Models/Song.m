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
    
    self.songTitle = dictionary[@"title"];
    self.songURI = dictionary[@"uri"];
    self.songArtist = dictionary[@"artist"];
    self.songAlbum = dictionary[@"album"];
    self.songAlbumArt = dictionary[@"albumArtUrl"];

    self.songID = dictionary[@"_id"];
    self.createdAt = dictionary[@"createdAt"];
    
    return self;
}

- (id)initWithSpotifyDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.songTitle = dictionary[@"name"];
    self.songURI = dictionary[@"album"][@"images"][0][@"url"];
    NSString * artists = dictionary[@"artists"][0][@"name"];
    for (int i = 1; i< [dictionary[@"artists"] count]; i++){
        artists = [artists stringByAppendingString:@" and "];
        artists = [artists stringByAppendingString:dictionary[@"artists"][i][@"name"]];
    }
    self.songArtist = artists;
    self.songAlbum = dictionary[@"album"][@"name"];
    self.songAlbumArt = dictionary[@"album"][@"images"][0][@"url"];
    
    self.songID = dictionary[@"id"];
    //self.createdAt = dictionary[@"createdAt"];
    
    return self;
}

+ (NSArray *)songsWithSpotifyArray:(NSArray *)dicts {
    NSMutableArray *output = [NSMutableArray new];
    for (NSDictionary *dict in dicts) {
        [output addObject:[[Song alloc] initWithSpotifyDictionary:dict]];
    }
    return output;
}

+ (NSArray *)songsWithDatabaseArray:(NSArray *)dicts {
    NSMutableArray *output = [NSMutableArray new];
    for (NSDictionary *dict in dicts) {
        [output addObject:[[Song alloc] initWithDictionary:dict]];
    }
    return output;
}

@end
