//
//  CSWIntroViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 20/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWIntroViewController.h"

@interface CSWIntroViewController ()

@end

@implementation CSWIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont sanFranciscoFontWithSize:10],
                                                        NSForegroundColorAttributeName : [UIColor darkCSWBlueColor]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont sanFranciscoFontWithSize:10],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    [self performPush];
}

-(void) performPush{
    CSWManager * manager = [CSWManager sharedManager];
    if (![manager checkCredentialsStorage]) {
        [self performSegueWithIdentifier:@"pushToLogin" sender:self];
    }else{
        NSDictionary *cred = [manager getCredentials];
        [manager loginWithUsername:cred[@"username"]
                       andPassword:cred[@"password"]
                     andCompletion:^(NSArray *array){
//                         if (status) {
                            if ([array[0] isKindOfClass:[NSString class]]) {
                                AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Whoops!" andText:array[0] andCancelButton:false forAlertType:AlertFailure andColor:[UIColor darkCSWBlueColor]];
                                [alert setCornerRadius:15];
                                [alert setTextFont:[UIFont sanFranciscoFontWithSize:12]];
                                [alert show];
                            }
                            [self performSelector:@selector(pushToMain) withObject:nil afterDelay:0.1];
//                         }
                         
                     }];
        
    }
}

-(void) pushToMain{
    [self performSegueWithIdentifier:@"pushToMain" sender:self];
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

@end
