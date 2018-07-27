//
//  PartyListTableViewCell.m
//  
//
//  Created by Leah Xiao on 7/19/18.
//

#import "PartyCell.h"
#import "BackendAPIManager.h"

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
    [[BackendAPIManager shared] getAUser:party.ownerId withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        User *owner = [[User alloc] initWithDictionary:response.body.object];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.flavortextLabel.text = [NSString stringWithFormat:@"%@ • 1 Hacker Way", owner.name];
        });
    }];
}
@end
