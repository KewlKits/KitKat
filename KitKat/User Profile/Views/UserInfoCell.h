//
//  UserInfoCell.h
//  KitKat
//
//  Created by Natalie Ghidali on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Party.h"

@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *poolNum;
@property (weak, nonatomic) IBOutlet UILabel *queueNum;
@property (weak, nonatomic) IBOutlet UILabel *currentParty;

@property Party *party;
@property NSMutableArray<Song *> *pool;
@property NSMutableArray<Song *> *queue;
@property int numQ;
@property int numP; 

-(void)setAttributes:(User*) currentUser;

@end
