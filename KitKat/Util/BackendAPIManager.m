//
//  BackendAPIManager.m
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "BackendAPIManager.h"

@implementation BackendAPIManager


//get endpt
+ (void)getAllParties:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        NSLog(@"here in get all parties");
        [simpleRequest setUrl:@"https://kk-backend.herokuapp.com/party/"];
    }] asJsonAsync:completion];
}


//post endpt
+ (void)makeParty:(NSString *) partyName longitude:(NSNumber *)longitude latitude: (NSNumber *) latitude withCompletion:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest postEntity:^(UNIBodyRequest *unibodyRequest) {
        [unibodyRequest setUrl:@"https://kk-backend.herokuapp.com/party"];
        [unibodyRequest setHeaders: @{@"Content-Type": @"application/json"}];
       [unibodyRequest setBody:[NSJSONSerialization dataWithJSONObject:@{@"name":partyName,@"longitude":longitude, @"latitude":latitude} options:0 error:nil]];
    }] asJsonAsync:completion];
    
}

// get enpt
+ (void) getAParty: (NSString *) partyId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion{
    NSString *preURL = [@"https://kk-backend.herokuapp.com/party/" stringByAppendingString:partyId];
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        NSLog(@"here in get a prty ");
        [simpleRequest setUrl:preURL];

    }] asJsonAsync:completion];
}

+(void) deleteParty: (NSString *) partyId withCompletion: (void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    NSString *preURL = [@"https://kk-backend.herokuapp.com/party/" stringByAppendingString:partyId];

    [[UNIRest delete:^(UNISimpleRequest *simpleRequest) {
        NSLog(@"here in delete party");
        [simpleRequest setUrl:preURL];
    }] asJsonAsync:completion];
}
@end
