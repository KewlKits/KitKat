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
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumCover;
-(void)setAttributes:(Song *) song;
@property Song * song;
@end
