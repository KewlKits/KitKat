//
//  PartySummaryCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 8/8/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "PartySummaryCell.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "PartyDetailViewController.h"
#import "BackendAPIManager.h"
#import "SpotifyDataManager.h"

@implementation PartySummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setAttributes: (Party *) party{
    self.nameLabel.text = self.party.name;
    self.party = party;
    [[BackendAPIManager shared] getAUser:self.party.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        if (!error) {
            User *owner = [[User alloc] initWithDictionary:response.body.object];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                self.ownerLabel.text = [NSString stringWithFormat:@"Host: %@", owner.name];
            });
        }
    }];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocation *partyLocation = [[CLLocation alloc] initWithLatitude:[self.party.location[1] doubleValue] longitude:[self.party.location[0] doubleValue]];
    
    [geocoder reverseGeocodeLocation:partyLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(!error && placemarks && placemarks.count > 0) {
            self.addressLabel.text = [NSString stringWithFormat:@"%@", placemarks[0].name];
        }
        else {
            self.addressLabel.text = @"Unknown location";
        }
    }];
    
    self.counterLabel.text = [NSString stringWithFormat:@"%lu in pool • %lu in queue", self.party.pool.count, self.party.queue.count];
    
    [[BackendAPIManager shared] getSongArray:self.party.queue withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        self.queue = [Song songsWithArray:response.body.array];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self setAlbumArts];
        });
    }];
}

- (void)setAlbumArts {
    NSArray<UIImageView *> *albumArts = @[self.albumArtTopLeft, self.albumArtTopRight, self.albumArtBottomLeft, self.albumArtBottomRight];
    if (self.queue.count > 0) {
        for (int i = 0; i < 4; i += 1) {
            if (i < self.queue.count) {
                [albumArts[i] setImageWithURL:[NSURL URLWithString:self.queue[i].songAlbumArt]];
            } else {
                [albumArts[i] setImageWithURL:[NSURL URLWithString:self.queue[self.queue.count - 1].songAlbumArt]];
            }
        }
    }
}
@end
