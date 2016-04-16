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
        [self getUserInfo];
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
    
    if ([username isEqualToString:@"test"] && [password isEqualToString:@"password"]) {
        username = @"msandrin2016";
        password = @"Cambridge96";
    }
    
    NSDictionary *params = @{
                            @"Username":username,
                            @"Password":password
                            };
    
//    NSLog(@"user: %@ pass: %@",username,password);
    
    NSString *url = [NSString stringWithFormat:@"%@/api/SignIn",kBaseLink];
    
//    NSLog(@"%@",url);
    
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
    
//    NSLog(@"%@",url);
    
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

-(void) getUserInfo{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/webapp/context",kBaseLink];
    [self.manager GET:url
           parameters:nil
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  self.userInfo = (NSDictionary*)responseObject;
                  NSLog(@"userinfo: %@",self.userInfo);
              } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                  [self getUserInfo];
              }];
    
}


-(void) getScheduleForDate:(NSDate*)date withCompletion:(ArrayResponseBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/schedule/MyDayCalendarStudentList",kBaseLink];

//    NSLog(@"%@",url);
    
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
//              NSLog(@"%@",responseObject);
              completionBlock(result);
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"failure: %@",error.localizedDescription);
              if (completionBlock) {
                  completionBlock(@[error.localizedDescription]);
              }
          }];
    
}

-(void) getAssignmentsSummaryForDueDate:(NSDate *)dueDate andSearchMode:(int)mode withCompletion:(ArrayResponseBlock)completionBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/DataDirect/AssignmentCenterAssignments",kBaseLink];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:dueDate];
#warning just for testing purposes
//    NSString *stringFromDate = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:1449674170]];
    
    NSDictionary *params = @{
                             @"persona": @"2",
                             @"format" : @"json",
                             @"filter" : [NSString stringWithFormat:@"%d",mode],
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
//             NSLog(@"%@",responseObject);
//             NSLog(@"%@",operation.request.URL);
             completionBlock(result);
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@",error.localizedDescription);
             if (completionBlock) {
                 completionBlock(@[error.localizedDescription]);
             }

         }];
    
//#warning Change this before going into production
    
}

-(void) getClassDetailWithId:(NSString *)idNumber andCompletion:(ArrayResponseBlock)completionBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@/api/datadirect/SectionInfoView",kBaseLink];
    
//    NSLog(@"%@",url);
    
    NSDictionary *params = @{
                             @"associationId": @"1",
                             @"sectionId": idNumber
                             };
    
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"success");
             NSArray *result = (NSArray*)responseObject;
//             NSLog(@"%@",responseObject);
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
    
//    NSLog(@"%@",url);
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"success");
             NSArray *result = (NSArray*)responseObject;
             NSLog(@"%@",responseObject);
             completionBlock(result);
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//             NSLog(@"failure: %@",error.localizedDescription);
             if (completionBlock) {
                 completionBlock(@[error.localizedDescription]);
             }
         }];
    
}

-(void) getThumbWithURL:(NSString*)url andCompletion:(ImageResponseBlock)completionBlock{
    
    url = [[NSString stringWithFormat:@"%@/ftpimages/424/user/%@",kBaseLink,url] stringByReplacingOccurrencesOfString:@"thumb_user" withString:@"large_user"];
//    NSLog(@"image url: %@",url);
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Response: %@", responseObject);
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

-(void) getPeopleWithQuery:(NSString *)query andGrade:(int)grade andDirectory:(int)directory andCompletion:(ArrayResponseBlock)completionBlock{
    
    if (query != nil && query.length > 2) {
        
        NSString *grade_param = [NSString stringWithFormat:@"1783_%d",grade];
        NSString *directory_param = [NSString stringWithFormat:@"%d",directory]; // 851 for students, 1259 for faculty & staff
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"directoryId"] = directory_param;
        params[@"searchVal"] = query;
        params[@"searchAll"] = @"false";
        
        if (directory == 851) {
            if (grade == 0) {
                params[@"facets"] = @"";
            }else{
                params[@"facets"] = grade_param;
            }
        }else if (directory == 1259){
            params[@"facets"] = @"";
        }
        
        NSString *url = [NSString stringWithFormat:@"%@/api/directory/directoryresultsget",kBaseLink];
        
//        NSLog(@"params: %@",params);
        
        [manager GET:url
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSLog(@"success");
                 NSArray *result = (NSArray*)responseObject;
//                 NSLog(@"roster: %@",responseObject);
                 if (completionBlock) {
                     completionBlock(result);
                 }
                 
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"failure: %@",error.localizedDescription);
                 if (completionBlock) {
                     completionBlock(@[error.localizedDescription]);
                 }
             }];
    }

}

-(void) getPersonWithId:(NSString *)num andCompletionBlock:(JSONResponseBlock)completionBlock{
    
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/user/%@/",kBaseLink,num];
    
//    NSLog(@"%@",url);
    
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"success");
             NSDictionary *result = (NSDictionary*)responseObject;
//             NSLog(@"%@",responseObject);
             completionBlock(result);
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@",error.localizedDescription);
             if (completionBlock) {
                 completionBlock(@{@"error":error.localizedDescription});
             }
         }];
    
}

-(void) getReportCardsWithCompletionBlock:(ArrayResponseBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/datadirect/ParentStudentUserPerformance/",kBaseLink];
    
//    NSLog(@"%@",url);
    
    NSDictionary *params = @{
                             @"personaId" : @2
                             };
    
    [manager GET:url
      parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSLog(@"success");
             NSArray *result = (NSArray*)responseObject;
//             NSLog(@"reports: %@",responseObject);
             if (completionBlock) {
                 completionBlock(result);
             }
             
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"failure: %@",error.localizedDescription);
             if (completionBlock) {
                 completionBlock(@[error.localizedDescription]);
             }
         }];
    
}

-(void) getReportPdfFileWithReportId:(NSString*)reportId andUserId:(NSString*)userId andSchoolYear:(NSString*)schoolYear andCompletionBlock:(ArrayResponseBlock)completionBlock{

    NSMutableArray *contentTypes = [NSMutableArray arrayWithArray:[self.manager.responseSerializer.acceptableContentTypes allObjects]];
    [contentTypes addObject:@"application/pdf"];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/podium/default.aspx",kBaseLink];
    
    NSDictionary *params = @{
                             @"t":@"1691",
                             @"wapp":@"1",
                             @"ch":@"1",
                             @"pk":@"162",
                             @"ext":@"pdf",
                             @"o_pk":[NSString stringWithFormat:@"|%@|%@|%@|User|1|0|1|8|0|",userId,reportId,schoolYear]
                             };
    
    [self.manager GET:url
           parameters:params
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//                  NSLog(@"%@",responseObject);
//                  NSLog(@"%@",operation.response.URL);
                  self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
                  completionBlock(@[responseObject]);
              }
              failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                  self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
                  completionBlock(@[error.localizedDescription]);
              }];
    
}

-(void) setAssignmentStatusWithId:(NSString*)assignmentId andStatusCode:(int)code {
    
    //[in progress] **(0)**
    //[completed] **(1)**
    //[overdue/not yet done] **(2)**
    
    [self getHtmlPageForAuthTokenWithCompletion:^(NSString *string) {
        
        if (string.length > 0) {
    
//            AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//            [self.manager.requestSerializer setValue:string forHTTPHeaderField:@"requestverificationtoken"];
            [self.manager.requestSerializer setValue:@"https://csw.myschoolapp.com" forHTTPHeaderField:@"Origin"];
            [self.manager.requestSerializer setValue:@"https://csw.myschoolapp.com/app/student" forHTTPHeaderField:@"Referer"];
            [self.manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.103 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
//            [self.manager setRequestSerializer:serializer];
            
            NSString *url = [NSString stringWithFormat:@"%@/api/assignment2/assignmentstatusupdate",kBaseLink];
            
//            NSString *url = [NSString stringWithFormat:@"%@/api/assignment2/assignmentstatusupdate?format=json",kBaseLink];
            NSLog(@"url: %@",url);
        
//            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            for (NSHTTPCookie *each in cookieStorage.cookies) {
//                [cookieStorage deleteCookie:each];
//            }

    
//            NSLog(@"%@",cookieStorage);

            
            NSDictionary *params = @{
                                     @"assignmentIndexId":assignmentId,
                                     @"assignmentStatus":[NSString stringWithFormat:@"%d",code]
                                     };
            
            NSLog(@"params: %@",params);
            NSLog(@"headers: %@",self.manager.requestSerializer.HTTPRequestHeaders);
            
            [manager POST:url
                    parameters:params
                       success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                           NSLog(@"Assignment %@ was successfully set to %d",assignmentId,code);
                           NSLog(@"%@",operation.responseString);
                       }
                       failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                           NSLog(@"error: %@",error.localizedDescription);
                           NSLog(@"%@",operation.request.URL);
                           NSLog(@"%@",operation.responseString);
                       }];
        }
    }];

}

-(void) getHtmlPageForAuthTokenWithCompletion:(StringResponseBlock)completionBlock{
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSMutableArray *contentTypes = [NSMutableArray arrayWithArray:[self.manager.responseSerializer.acceptableContentTypes allObjects]];
//    [contentTypes addObject:@"text/html"];
//    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];

    [self.manager GET:@"https://csw.myschoolapp.com/app/student" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"response: %@",[operation.responseString componentsSeparatedByString:@"\n"]);
        NSArray *lines = [operation.responseString componentsSeparatedByString:@"\n"];
        NSString *result = @"";
        for (NSString *l in lines) {
            if ([l rangeOfString:@"RequestVerificationToken"].location != NSNotFound) {
                for (NSString* p in [l componentsSeparatedByString:@" "]) {
                    if ([p rangeOfString:@"value"].location != NSNotFound) {
                        result = [p stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        result = [result stringByReplacingOccurrencesOfString:@"value=" withString:@""];
                    }
                }
            }
        }
        NSLog(@"token: %@",result);
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        completionBlock(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@",error.localizedDescription);
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        completionBlock(@"");
    }];
    
}

-(void) getMealsListWithCompletionBlock:(ArrayResponseBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/download/forresourceboard/?format=json&categoryId=16285&itemCount=0",kBaseLink];
    
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

-(void) getMealPdfFileWithUrl:(NSString *)mealUrl andCompletionBlock:(ArrayResponseBlock)completionBlock{
    
    NSMutableArray *contentTypes = [NSMutableArray arrayWithArray:[self.manager.responseSerializer.acceptableContentTypes allObjects]];
    [contentTypes addObject:@"application/pdf"];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kBaseLink,mealUrl];
    
    
    [self.manager GET:url
           parameters:nil
              success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                  //                  NSLog(@"%@",responseObject);
                  //                  NSLog(@"%@",operation.response.URL);
                  self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
                  completionBlock(@[responseObject]);
              }
              failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                  self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
                  completionBlock(@[error.localizedDescription]);
              }];
    
}


@end
