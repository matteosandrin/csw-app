//
//  CSWManager.m
//  csw-app
//
//  Created by Matteo Sandrin on 20/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWManager.h"

@implementation CSWManager

@synthesize manager;

+(CSWManager*)sharedManager {
    static CSWManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(CSWManager*) init {
    if (self == [super init]) {
        
        manager = [AFHTTPRequestOperationManager manager];
//        [self deleteCredentials];
        NSLog(@"init manager");
        
    }
    return self;
}

#pragma login procedure

-(void) deleteCredentials{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"pass_keychain" accessGroup:nil];
    [keychainItem setObject:@"" forKey:(id)CFBridgingRelease(kSecAttrAccount)];
    [keychainItem setObject:@"" forKey:(id)CFBridgingRelease(kSecValueData)];
}

-(NSDictionary*) getCredentials{
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"pass_keychain" accessGroup:nil];
    NSString *username = (NSString*)[keychainItem objectForKey:(id)CFBridgingRelease(kSecAttrAccount)];
    NSString *password = [keychainItem objectForKey:(id)CFBridgingRelease(kSecValueData)];
    
    return @{
             @"username":username,
             @"password":password
             };
    
}

-(BOOL) checkCredentialsStorage {
    
    NSDictionary *cred = [self getCredentials];
    NSString *user = cred[@"username"];
    NSString *pass = cred[@"password"];
    if (user != nil && pass != nil) {
        if (user.length > 0 && pass.length > 0) {
            return true;
        }
    }
    return false;
    
}

-(void) loginWithUsername:(NSString*)username andPassword:(NSString*)password andCompletion:(ArrayResponseBlock)completionBlock{
    
    NSDictionary *params = @{
                            @"Username":username,
                            @"Password":password
                            };
    
    NSLog(@"user: %@ pass: %@",username,password);
    
    NSString *url = [NSString stringWithFormat:@"%@/api/SignIn",kBaseLink];
    
    NSLog(@"%@",url);
    
    [manager POST:url
       parameters:params constructingBodyWithBlock:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *result = (NSDictionary*)responseObject;
              NSNumber *status = result[@"AuthenticationResult"];
              if ([status  isEqual: @0]) {
                  NSLog(@"login successful");
                  KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"pass_keychain" accessGroup:nil];
                  [keychainItem setObject:username forKey:(id)CFBridgingRelease(kSecAttrAccount)];
                  [keychainItem setObject:password forKey:(id)CFBridgingRelease(kSecValueData)];
                  
              }else{
                  NSLog(@"login failed");
                  
              }
              
              if (completionBlock) {
                  NSLog(@"what");
                  completionBlock(@[[NSNumber numberWithBool:![status boolValue]]]);
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (completionBlock) {
                  completionBlock(@[error.localizedDescription]);
              }
              NSLog(@"faillogin");
          }];

    
}

-(void) validateCookiesStatusWithCompletion:(BoolResponseBlock)completionBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/webapp/userstatus",kBaseLink];
    
    NSLog(@"%@",url);
    
    [manager GET:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *result = (NSDictionary*)responseObject;
              NSNumber *status = result[@"TokenValid"];
              if (completionBlock) {
                  completionBlock([status boolValue]);
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (completionBlock) {
                  completionBlock(false);
              }
          }];
    
}

#pragma get data


-(void) getScheduleForDate:(NSDate*)date withCompletion:(ArrayResponseBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/schedule/MyDayCalendarStudentList",kBaseLink];

    NSLog(@"%@",url);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    NSDictionary *params = @{
                             @"personaId": @"2",
                             @"scheduleDate": stringFromDate
                             };
    
    [manager GET:url
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"success");
              NSArray *result = (NSArray*)responseObject;
              NSLog(@"%@",responseObject);
              completionBlock(result);
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"failure: %@",error.localizedDescription);
              if (completionBlock) {
                  completionBlock(@[error.localizedDescription]);
              }
          }];
    
}

-(void) getAssignmentsSummaryForDueDate:(NSDate *)dueDate withCompletion:(ArrayResponseBlock)completionBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/DataDirect/AssignmentCenterAssignments",kBaseLink];
    
    NSLog(@"%@",url);
    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    
//    NSDateComponents* comp = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
//    
//    int todayWeek = [comp weekday];
//    int add = 1;
//    
//    switch (todayWeek) {
//        case 6:
//            add = 3;
//            break;
//        case 7:
//            add = 2;
//            break;
//    }
//    
//    NSDate *tomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay
//                                             value:add
//                                            toDate:[NSDate date]
//                                           options:kNilOptions];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:dueDate];
    
    NSDictionary *params = @{
                             @"persona": @"2",
                             @"format" : @"json",
                             @"filter" : @"1",
                             @"dateStart" : stringFromDate,
                             @"dateEnd" : stringFromDate,
                             @"statusList" : @"",
                             @"sectionList" : @""
                             };
    

    
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"success");
             NSArray *result = (NSArray*)responseObject;
             NSLog(@"%@",responseObject);
             NSLog(@"%@",operation.request.URL);
             completionBlock(result);
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@",error.localizedDescription);
             if (completionBlock) {
                 completionBlock(@[error.localizedDescription]);
             }
//             NSLog(@"%@",operation.responseString);
         }];
    
}

-(void) getClassDetailWithId:(NSString *)idNumber andCompletion:(ArrayResponseBlock)completionBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/datadirect/SectionInfoView",kBaseLink];
    
    NSLog(@"%@",url);
    
    NSDictionary *params = @{
                             @"associationId": @"1",
                             @"sectionId": idNumber
                             };
    
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"success");
             NSArray *result = (NSArray*)responseObject;
             NSLog(@"%@",responseObject);
             completionBlock(result);
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@",error.localizedDescription);
             if (completionBlock) {
                 completionBlock(@[error.localizedDescription]);
             }
         }];
    
}

-(void) getRosterForClassWithId:(NSString *)idNumber andCompletion:(ArrayResponseBlock)completionBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/datadirect/sectionrosterget/%@/",kBaseLink,idNumber];
    
    NSLog(@"%@",url);
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"success");
             NSArray *result = (NSArray*)responseObject;
             NSLog(@"%@",responseObject);
             completionBlock(result);
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@",error.localizedDescription);
             if (completionBlock) {
                 completionBlock(@[error.localizedDescription]);
             }
         }];
    
}

-(void) getThumbWithURL:(NSString*)url andCompletion:(ImageResponseBlock)completionBlock{
    
    url = [[NSString stringWithFormat:@"%@/ftpimages/424/user/%@",kBaseLink,url] stringByReplacingOccurrencesOfString:@"thumb_user_" withString:@"large_user_"];
    NSLog(@"image url: %@",url);
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        NSLog(@"failure: %@",error.localizedDescription);
        if (completionBlock) {
            completionBlock(nil);
        }
    }];
    [requestOperation start];
}


@end
