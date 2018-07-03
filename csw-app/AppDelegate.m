//
//  AppDelegate.m
//  csw-app
//
//  Created by Matteo Sandrin on 22/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor darkCSWBlueColor]
                                  highlightedColor:[UIColor cloudsColor]
                                      cornerRadius:3];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    CSWManager *manager = [CSWManager sharedManager];
    
    [manager validateCookiesStatusWithCompletion:^(BOOL status) {
        if (!status) {
            NSLog(@"The cookies are nolonger valid!");
            NSDictionary *cred = [manager getCredentials];
            [manager loginWithUsername:cred[@"username"]
                           andPassword:cred[@"password"]
                         andCompletion:nil];
        }
    }];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
//    NSLog(@"background refresh ");
//    
//    CSWManager *manager = [CSWManager sharedManager];
//    
//    if ([manager checkCredentialsStorage]) {
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSArray *savedHomework = [defaults objectForKey:@"savedHomework"];
//        
////        savedHomework = nil; //testing purposes
//        
//        if (savedHomework == nil) {
//            savedHomework = [NSArray array];
//        }
//
////        NSLog(@"savedHW: %@",savedHomework);
//        
//        ArrayResponseBlock block = ^(NSArray *array){
//            NSLog(@"getting homework");
//            if (array.count > 0) {
//                if (![array[0] isKindOfClass:[NSString class]]) {
//                    NSLog(@"no error, all clear");
//                    NSMutableArray *newHomework = [NSMutableArray array];
//                    
//                    BOOL shouldSaveHomework = false;
//                    
//                    for (NSDictionary *newAssignment in array) {
//                        NSNumber *id_num = newAssignment[@"assignment_id"];
//                        [newHomework addObject:id_num];
//                    }
//                    
//                    for (NSDictionary *new in array) {
//                        NSMutableDictionary *newAssignment = [NSMutableDictionary dictionaryWithDictionary:new];
////                        NSLog(@"assignment: %@",newAssignment);
//                        NSNumber *newId = newAssignment[@"assignment_id"];
//                        if (![savedHomework containsObject:newId]) {
//                            NSLog(@"NEW ONE");
//                            
//                            NSString *name = [newAssignment[@"groupname"] componentsSeparatedByString:@"-"][0];
//                            NSString *desc = [NSString stringWithFormat:@"%@: New assignment",name];
//                            
//                            for (NSString *key in [newAssignment allKeys]) {
//                                if ([newAssignment[key] isKindOfClass:[NSNull class]]) {
//                                    newAssignment[key] = nil;
//                                }
//                            }
//                            
//                            if ([[newAssignment allKeys] containsObject:@"short_description"]) {
//                                NSString *shortDesc = newAssignment[@"short_description"];
//                                if (shortDesc != nil && shortDesc.length > 0) {
//                                    desc = [NSString stringWithFormat:@"%@: %@",name,shortDesc];
//                                }
//                                
//                            }
//                            NSLog(@"assignment: %@",newAssignment);
//                            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//                            localNotification.fireDate = [NSDate date];
//                            localNotification.alertBody = [[[NSAttributedString alloc] initWithData:[desc dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil] string];
//                            localNotification.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//                            localNotification.soundName = UILocalNotificationDefaultSoundName;
//                            localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
//                            localNotification.userInfo = newAssignment;
//                            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//                            shouldSaveHomework = true;
//                        }
//                        [newHomework addObject:newId];
//                    }
//                    
//                    if (shouldSaveHomework) {
//                        [defaults setObject:newHomework forKey:@"savedHomework"];
//                    }
//                    
//                }else{
//                    NSLog(@"error: %@",array[0]);
//                }
//            }
//            completionHandler(UIBackgroundFetchResultNewData);
//            
//        };
//        
//        [manager validateCookiesStatusWithCompletion:^(BOOL status) {
//            if (status) {
//                NSLog(@"status: good cookies");
//                [manager getAssignmentsSummaryForDueDate:[NSDate date] andSearchMode:2 withCompletion:block];
//            }else{
//                NSLog(@"status: bad cookies");
//                NSDictionary *cred = [manager getCredentials];
//                [manager loginWithUsername:cred[@"username"]
//                               andPassword:cred[@"password"]
//                             andCompletion:^(NSArray *array) {
//                                 NSLog(@"logged in");
//                                 [manager getAssignmentsSummaryForDueDate:[NSDate date] andSearchMode:2 withCompletion:block];
//                             }];
//            }
//        }];
//    }else{
//        completionHandler(UIBackgroundFetchResultNoData);
//    }
}

//-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    
//    CSWIntroViewController *controller = (CSWIntroViewController*)self.window.rootViewController;
//    NSLog(@"heyhey: %@",notification.userInfo);
//    controller.pushAssignmentDict = notification.userInfo;
//    
//    
//}


@end
