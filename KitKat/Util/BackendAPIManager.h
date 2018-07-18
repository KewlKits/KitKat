//
//  BackendAPIManager.h
//  KitKat
//
//  Created by Miles Olson on 7/18/18.
//  Copyright © 2018 kewlkits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UNIRest.h>

@interface BackendAPIManager : NSObject
+ (void)getAllParties:(void (^_Nullable)(UNIHTTPJsonResponse*, NSError*))completion;
@end
