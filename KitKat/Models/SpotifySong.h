//
//  SpotifySong.h
//  KitKat
//
//  Created by Miles Olson on 7/24/18.
//  Copyright © 2018 kewlkits. All rights reserved.
////

#import <Foundation/Foundation.h>

@interface SpotifySong : NSObject

@property (nonatomic, strong) NSString *songUri;
@property (nonatomic, strong) NSString *songTitle;
@property (nonatomic, strong) NSString *songArtist;
@property (nonatomic, strong) NSString *songAlbum;
@property (nonatomic, strong) NSString *songAlbumArt;

+ (NSArray<SpotifySong *> *)songsWithArray:(NSArray *)dicts;
@end
