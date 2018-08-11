//
//  UserCell.m
//  KitKat
//
//  Created by Natalie Ghidali on 7/27/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "UserCell.h"
#import "BackendAPIManager.h"


@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAttributes:(Song *)song{
    self.thisSong = song;
    [super setAttributes:song];
 //   NSString *partyName = song.partyId;
//    __block Party *thisParty;
 //   [self getSongParty:^{}];
 //   NSLog(@"PARTY LABEL IN THE USER CELL %@", self.thisParty.name);
 //   self.partyLabel.text = [NSString stringWithFormat:@"In party: %@", self.thisParty.name];
    self.partyLabel.text = @""; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) getSongParty: (void (^_Nullable)(void))completion {
    NSString *partyName = self.thisSong.partyId;
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse *response, NSError *error) {
        for (NSDictionary *dict in response.body.array) {
            Party *temp = [[Party alloc] initWithDictionary:dict];
            if ([temp.partyId isEqualToString: partyName]){
                self.thisParty = temp;
                break;
            }
        }
        
        if(completion) {
            completion();
        }
        
    }];
    
}


@end
