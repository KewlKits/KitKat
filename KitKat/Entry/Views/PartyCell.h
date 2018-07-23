//
//  PartyListTableViewCell.h
//  
//
//  Created by Leah Xiao on 7/19/18.
//

#import <UIKit/UIKit.h>
#import "Party.h"

@interface PartyCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameOfPartyLabel;

@property (strong, nonatomic) Party *party;

@end
