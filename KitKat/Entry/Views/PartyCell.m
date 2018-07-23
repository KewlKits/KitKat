//
//  PartyListTableViewCell.m
//  
//
//  Created by Leah Xiao on 7/19/18.
//

#import "PartyCell.h"

@implementation PartyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setParty:(Party *)party{
    _party= party;
    self.nameOfPartyLabel.text = party.name;
}
@end
