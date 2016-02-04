//
//  CSWSettingsViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 23/01/16.
//  Copyright © 2016 Matteo Sandrin. All rights reserved.
//

#import "CSWSettingsViewController.h"

@interface CSWSettingsViewController ()

@end

@implementation CSWSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setup{
    self.title = @"Settings";
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"General" handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Sign out" key:nil handler:^(id cell) {
            BOButtonTableViewCell *c =  (BOButtonTableViewCell*)cell;
            c.actionBlock = ^{
            
                [[CSWManager sharedManager] deleteCredentials];
                [self.navigationController performSegueWithIdentifier:@"pushToSignOut" sender:self];
                
            };
        }]];
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"About" handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Send feedback" key:nil handler:^(id cell) {
            BOButtonTableViewCell *c =  (BOButtonTableViewCell*)cell;
            c.actionBlock = ^{
            
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                picker.mailComposeDelegate = self;
                
                [picker setSubject:@"CSW App - Feedback"];
                NSDate *date = [NSDate date];
                NSTimeZone *tz = [NSTimeZone localTimeZone];
                NSInteger seconds = [tz secondsFromGMTForDate:date];
                date = [NSDate dateWithTimeInterval:seconds sinceDate:date];
                [picker setMessageBody:[NSString stringWithFormat:@"Report a bug or suggest a feature.<br /><br /> Device: %@<br />Version: %@<br />Date: %@",deviceName(),[[UIDevice currentDevice] systemVersion],[date description]] isHTML:YES];
                [picker setToRecipients:@[@"cswapp@csw.org"]];
                [self presentViewController:picker animated:true completion:nil];

                
            };
        }]];
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Acknowledgements" key:nil handler:^(id cell) {
            BOButtonTableViewCell *c =  (BOButtonTableViewCell*)cell;
            c.actionBlock = ^{
            
                TRZSlideLicenseViewController *controller = [[TRZSlideLicenseViewController alloc] init];
                controller.podsPlistName = @"Pods-acknowledgements.plist";
                controller.navigationItem.title = @"";
                UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings "
                                                 style:UIBarButtonItemStylePlain
                                                target:nil
                                                action:nil];
                [[self navigationItem] setBackBarButtonItem:newBackButton];
                [self.navigationController pushViewController:controller animated:YES];
            
            };
        }]];
    }]];
    
    [self.view setBackgroundColor:[UIColor cloudsColor]];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
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
