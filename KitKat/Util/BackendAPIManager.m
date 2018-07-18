//
//  BackendAPIManager.m
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import "BackendAPIManager.h"

@implementation BackendAPIManager
+ (void)getAllParties:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion {
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:@"https://kk-backend.herokuapp.com/party"];
    }] asJsonAsync:completion];
}
@end
