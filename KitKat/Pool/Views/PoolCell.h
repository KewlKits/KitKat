//
//  PoolCell.h
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractSongCell.h"

//@protocol PoolCellDelegate
//-(void) voteDone: (Song *) song;
//@end

@interface PoolCell : AbstractSongCell
@property (weak, nonatomic) IBOutlet UIButton *moveToQueueButton;
@property (weak, nonatomic) IBOutlet UIButton *downvoteButton;
@property (weak, nonatomic) IBOutlet UILabel *songVotesLabel;
@property (weak, nonatomic) IBOutlet UIButton *upvoteButton;

//@property(nonatomic, weak) id<PoolCellDelegate> delegate;

-(void)setVoteAttributes:(Song *)song;

@end

