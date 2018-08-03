//
//  UserInfoCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "UserInfoCell.h"
#import "BackendAPIManager.h"


@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAttributes:(User*) currentUser{
    self.usernameLabel.text = currentUser.name;
    [currentUser calcScore]; 
    self.rankLabel.text = [NSString stringWithFormat:@"Score: %@", currentUser.score];
}
@end
