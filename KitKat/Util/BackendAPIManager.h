//
//  BackendAPIManager.h
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UNIRest.h>
#import "Party.h"
#import "User.h"

@interface BackendAPIManager : NSObject
@property (strong, nonatomic) ProtoUser *currentProtoUser;
@property (strong, nonatomic) ProtoParty *currentProtoParty;

+ (instancetype)shared;
+ (void)getAllParties:(void (^_Nonnull)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)makeParty:(NSString *) partyName longitude:(NSNumber *)longitude latitude: (NSNumber *) latitude playlistUri:(NSString *) playlistUri withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)getAParty: (NSString *) partyId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)deleteParty: (NSString *) partyId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)addSongToPool:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)removeSongFromPool:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)moveSongFromPoolToQueue:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)addSongToQueue:(NSString*) partyId uri:(NSString*)uri title:(NSString*) title artist:(NSString*) artist album:(NSString*) album albumArtUrlString:(NSString*)albumArtUrlString withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)removeSongFromQueue:(NSString*) partyId songId:(NSString*) songId withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)moveSongWithinQueue:(NSString*) partyId index:(NSNumber*) index target:(NSNumber*) target withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)getAllUsers:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)makeUser:(NSString *) name withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)touchUser:(NSString *) name withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)getAUser: (NSString *) userId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)getAllSongs:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)getASong: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
-(void) getSongArray: (NSArray<NSString *> *) songIds withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)upvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)unUpvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)downvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)unDownvote: (NSString *) songId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)updateScore: (NSString *) userId score: (NSNumber*) score withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
- (void)setNowPlaying: (NSString *) songURI withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
@end
