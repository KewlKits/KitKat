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
    
    [BackendAPIManager addSongToPool:@"5b4d0af735012e00043c91a2" uri:@"1118" title:@"Sunflower" artist:@"Rex OC" album:@"Sunflower - Single" albumArtUrlString:@"googleit" withCompletion:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSLog(@"%@", response.body);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
