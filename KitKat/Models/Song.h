//
//  Song.h
//  KitKat
//
//  Created by Leah Xiao on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, strong) NSString *songId;
@property (nonatomic, strong) NSString *songURI;
@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSString *songArtist;
@property (nonatomic, strong) NSString *songAlbum;
@property (nonatomic, strong) NSString *songAlbumArt;
@property (nonatomic, strong) NSDate *createdAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray<Song *> *)songsWithSpotifyArray:(NSArray *)dicts;
+ (NSArray<Song *> *)songsWithDatabaseArray:(NSArray *)dicts;
@end
