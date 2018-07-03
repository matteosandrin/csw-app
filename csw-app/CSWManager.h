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
typedef void (^StringResponseBlock)(NSString* string);
#define kBaseLink @"https://csw.myschoolapp.com"

@interface CSWManager : NSObject

+(CSWManager*) sharedManager;

-(BOOL) checkCredentialsStorage;
-(NSDictionary*) getCredentials;
-(void) getUserInfo;
-(void) loginWithUsername:(NSString*)username andPassword:(NSString*)password andCompletion:(ArrayResponseBlock)completionBlock;
-(void) validateCookiesStatusWithCompletion:(BoolResponseBlock)completionBlock;
-(void) getScheduleForDate:(NSDate*)date withCompletion:(ArrayResponseBlock)completionBlock;
-(void) getAssignmentsSummaryForDueDate:(NSDate*)dueDate andSearchMode:(int)mode withCompletion:(ArrayResponseBlock)completionBlock;
-(void) getClassDetailWithId:(NSString*)idNumber andCompletion:(ArrayResponseBlock)completionBlock;
-(void) getRosterForClassWithId:(NSString*)idNumber andCompletion:(ArrayResponseBlock)completionBlock;
-(void) getThumbWithURL:(NSString*)url andCompletion:(ImageResponseBlock)completionBlock;
-(void) getPeopleWithQuery:(NSString*)query andGrade:(int)grade andDirectory:(int)directory andCompletion:(ArrayResponseBlock)completionBlock;
-(void) getPersonWithId:(NSString*)num andCompletionBlock:(JSONResponseBlock)completionBlock;
-(void) getReportCardsWithCompletionBlock:(ArrayResponseBlock)completionBlock;
-(void) getReportPdfFileWithReportId:(NSString*)reportId andUserId:(NSString*)userId andSchoolYear:(NSString*)schoolYear andCompletionBlock:(ArrayResponseBlock)completionBlock;
-(void) getMealsListWithCompletionBlock:(ArrayResponseBlock)completionBlock;
-(void) getMealPdfFileWithUrl:(NSString*)mealUrl andCompletionBlock:(ArrayResponseBlock)completionBlock;
-(void) getModStructureForUserId:(NSString*)userId andCompletionBlock:(ArrayResponseBlock)completionBlock;
-(void) getGradeInfoForUserId:(NSString*)userId andModId:(NSString*)modId andCompletionBlock:(ArrayResponseBlock)completionBlock;
-(void) getGradeBookForUserId:(NSString*)userId andSectionId:(NSString*)sectionId andPeriodId:(NSString*)periodId andCompletionBlock:(ArrayResponseBlock)completionBlock;
- (void) getAssignmentsSummaryForClass:(NSString*)sectionId onlyActive:(BOOL)isOnlyActive andCompletionBlock:(ArrayResponseBlock)completionBlock;

-(void) setAssignmentStatusWithId:(NSString*)assignmentId andStatusCode:(int)code; 
-(void) deleteCredentials;


@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong) NSDictionary *userInfo;

@end
