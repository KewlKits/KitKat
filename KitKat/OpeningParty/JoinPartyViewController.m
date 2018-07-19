//
//  JoinPartyViewController.m
//  KitKat
//
//  Created by Leah Xiao on 7/19/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "JoinPartyViewController.h"
#import "BackendAPIManager.h"



@interface JoinPartyViewController ()
@property (strong, nonatomic ) NSArray *partyList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation JoinPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Do any additional setup after loading the view.
    
    //[BackendAPIManager shared].party = party;
    
    // call the get all parties list.
    [BackendAPIManager getAllParties:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *dict in response.body.array) {
            Party *party = [[Party alloc] initWithDictionary:dict];
            [temp addObject:party];
        }
        self.partyList = temp;
        
    }];
     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self.tableView reloadData];
}

- (void)onTimer {
    // Add code to be run periodically
     [self.tableView reloadData];
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PartyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partyCell" forIndexPath:indexPath];
    [cell setParty: self.partyList[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", self.partyList.count);
    return self.partyList.count;
}

@end
