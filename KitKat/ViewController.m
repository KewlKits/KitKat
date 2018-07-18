//
//  ViewController.m
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "ViewController.h"
#import "Party.h"
#import "BackendAPIManager.h"

@interface ViewController ()
@property (strong, nonatomic) Party *party;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error.description);
        }
        else {
            NSLog(@"%@", response.body.array[0][@"name"]);
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
