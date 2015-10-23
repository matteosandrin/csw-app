//
//  CSWLoginViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 20/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "CSWManager.h"
#import "AMSmoothAlertView.h"

@interface CSWLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet FUITextField *userNameField;
@property (weak, nonatomic) IBOutlet FUITextField *passWordField;
@property (weak, nonatomic) IBOutlet FUIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageVerticalSpaceConstraint;

- (IBAction)logInButtonTapped:(id)sender;

@end
