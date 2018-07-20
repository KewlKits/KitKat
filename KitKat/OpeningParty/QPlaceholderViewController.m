//
//  QPlaceholderViewController.m
//  KitKat
//
//  Created by Leah Xiao on 7/20/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "QPlaceholderViewController.h"

@interface QPlaceholderViewController ()

@end

@implementation QPlaceholderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BackendAPIManager shared].party = self.party;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
