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
typedef void (^ImageResponseBlock)(UIImage* image);
#define kBaseLink @"https://csw.myschoolapp.com"

@interface CSWManager : NSObject

+(CSWManager*) sharedManager;

-(BOOL) checkCredentialsStorage;
-(NSDictionary*) getCredentials;
-(void) loginWithUsername:(NSString*)username andPassword:(NSString*)password andCompletion:(ArrayResponseBlock)completionBlock;
-(void) getScheduleForDate:(NSDate*)date withCompletion:(ArrayResponseBlock)completionBlock;
-(void) getAssignmentsSummaryForDueDate:(NSDate*)dueDate withCompletion:(ArrayResponseBlock)completionBlock;
-(void) getClassDetailWithId:(NSString*)idNumber andCompletion:(ArrayResponseBlock)completionBlock;
-(void) getRosterForClassWithId:(NSString*)idNumber andCompletion:(ArrayResponseBlock)completionBlock;
-(void) getThumbWithURL:(NSString*)url andCompletion:(ImageResponseBlock)completionBlock;
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end
