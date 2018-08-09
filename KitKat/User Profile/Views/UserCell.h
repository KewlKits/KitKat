//
//  UserCell.h
//  KitKat
//
//  Created by Natalie Ghidali on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractSongCell.h"
#import "Party.h"

@interface UserCell : AbstractSongCell
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;

@property Song *thisSong;
@property Party *thisParty;

@end
