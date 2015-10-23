//
//  CSWManager.h
//  csw-app
//
//  Created by Matteo Sandrin on 20/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "KeychainItemWrapper.h"

typedef void (^JSONResponseBlock)(NSDictionary* json);
typedef void (^ArrayResponseBlock)(NSArray* array);
typedef void (^BoolResponseBlock)(BOOL status);
#define kBaseLink @"https://csw.myschoolapp.com"

@interface CSWManager : NSObject

+(CSWManager*) sharedManager;

-(BOOL) checkCredentialsStorage;
-(NSDictionary*) getCredentials;
-(void) loginWithUsername:(NSString*)username andPassword:(NSString*)password andCompletion:(BoolResponseBlock)completionBlock;
-(void) getScheduleForDate:(NSDate*)date withCompletion:(ArrayResponseBlock)completionBlock;

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end
