//
//  QueueCell.h
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractSongCell.h"

@interface QueueCell : AbstractSongCell
-(void)setAttributes:(Song *)song nowPlayingId:(NSString *) nowPlayingId;
@end
