//
//  PoolCell.h
//  KitKat
//
//  Created by Natalie Ghidali on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoolCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

- (void) setAttributes: (NSDictionary *) track;

@property (weak, nonatomic) IBOutlet UIImageView *albumCover;

@end
