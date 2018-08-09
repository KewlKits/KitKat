//
//  UserCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "UserCell.h"
#import "BackendAPIManager.h"
#import "Party.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAttributes:(Song *)song{
    [super setAttributes:song];
    NSString *partyName = song.partyId;
    __block Party *thisParty;
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse *response, NSError *error) {
        for (NSDictionary *dict in response.body.array) {
            Party *temp = [[Party alloc] initWithDictionary:dict];
            if ([temp.partyId isEqualToString: partyName]){
                thisParty = temp;
                break;
            }
        }    
    }];
    self.partyLabel.text = thisParty.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
