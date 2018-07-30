//
//  AbstractSongCell.h
//  KitKat
//
//  Created by Miles Olson on 7/20/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface AbstractSongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumCover;
@property (weak, nonatomic) IBOutlet UIButton *addCheckButton;
-(void)setAttributes:(Song *) song;
-(void)setAddedButton:(Song *)song addedSongs:(NSArray <Song*>*)addedSongs;
@property Song * song;
@end
