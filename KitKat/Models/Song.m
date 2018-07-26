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
    
    self.songId = dictionary[@"_id"];
    self.songTitle = dictionary[@"title"];
    self.songUri = dictionary[@"uri"];
    self.songArtist = dictionary[@"artist"];
    self.songAlbum = dictionary[@"album"];
    self.songAlbumArt = dictionary[@"albumArtUrl"];
    self.createdAt = dictionary[@"createdAt"];
    
    self.partyId = dictionary[@"party"];
    self.ownerId = dictionary[@"owner"];
    self.upvotedBy = dictionary[@"upvotedBy"];
    self.downvotedBy = dictionary[@"downvotedBy"];
    
    return self;
}

+ (NSArray<Song *> *)songsWithArray:(NSArray *)dicts {
    NSMutableArray *output = [NSMutableArray new];
    for (NSDictionary *dict in dicts) {
        [output addObject:[[Song alloc] initWithDictionary:dict]];
    }
    return output;
}

@end
