//
//  CSWLoginViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 20/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWLoginViewController.h"

@interface CSWLoginViewController ()

@end

@implementation CSWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextFields];
    [self setupButton];
    NSLog(@"login");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupTextFields{
    
    self.userNameField.font = [UIFont sanFranciscoFontWithSize:17];
    self.userNameField.backgroundColor = [UIColor cloudsColor];
    self.userNameField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.userNameField.textFieldColor = [UIColor darkCSWBlueColor];
    self.userNameField.borderColor = [UIColor lightCSWBlueColor];
    self.userNameField.borderWidth = 2.0f;
    self.userNameField.cornerRadius = 3.0f;
    self.userNameField.delegate = self;
    
    self.passWordField.font = [UIFont sanFranciscoFontWithSize:17];
    self.passWordField.backgroundColor = [UIColor cloudsColor];
    self.passWordField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.passWordField.textFieldColor = [UIColor darkCSWBlueColor];
    self.passWordField.borderColor = [UIColor lightCSWBlueColor];
    self.passWordField.borderWidth = 2.0f;
    self.passWordField.cornerRadius = 3.0f;
    self.passWordField.delegate = self;
    
}

-(void) setupButton {
    
    self.logInButton.buttonColor = [UIColor darkCSWBlueColor];
    self.logInButton.shadowColor = [UIColor lightCSWBlueColor];
    self.logInButton.shadowHeight = 3.0f;
    self.logInButton.cornerRadius = 6.0f;
    self.logInButton.titleLabel.font = [UIFont sanFranciscoFontWithSize:20];
    [self.logInButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.logInButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
     }

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self moveDown];
    
}

-(void) moveDown {
    [self.view endEditing:YES];
    [self.topImageVerticalSpaceConstraint setConstant:55];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.logoImageView.alpha != 1.0f) {
            [self.view layoutIfNeeded];
            [self.logoImageView setAlpha:1];
        }
    }];
}

-(void) moveUp {
    [self.topImageVerticalSpaceConstraint setConstant:-100];
    [UIView animateWithDuration:0.3 animations:^{
        if (self.logoImageView.alpha != 0.0f) {
            [self.view layoutIfNeeded];
            [self.logoImageView setAlpha:0];
        }
    }];
}

#pragma TextField Delegate


-(void) textFieldDidBeginEditing:(UITextField *)textField{
    [self moveUp];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logInButtonTapped:(id)sender {
    
    [self.logInButton setEnabled:NO];
    [self.logInButton setTitle:@"" forState:UIControlStateDisabled];
    
    UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    // Position the spinner
    [myIndicator setCenter:CGPointMake(self.logInButton.frame.size.width / 2, self.logInButton.frame.size.height / 2)];
    
    // Add to button
    [self.logInButton addSubview:myIndicator];
    
    // Start the animation
    [myIndicator startAnimating];
    
    [self moveDown];
    CSWManager *manager = [CSWManager sharedManager];
    NSString *username = self.userNameField.text;
    NSString *password = self.passWordField.text;
    
    [manager loginWithUsername:username
                   andPassword:password
                 andCompletion:^(NSArray *array){
                     
                     if ([array[0] isKindOfClass:[NSNumber class]]) {
                         BOOL status = [array[0] boolValue];
                         if (status) {
                             [self performSelectorOnMainThread:@selector(pushToTab) withObject:nil waitUntilDone:false];
                         }else{
                             AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Whoops!" andText:@"It seems like either your Username or Password are wrong." andCancelButton:false forAlertType:AlertFailure andColor:[UIColor darkCSWBlueColor]];
                             [alert setCornerRadius:15];
                             [alert setTextFont:[UIFont sanFranciscoFontWithSize:12]];
                             [alert show];
                             [self.logInButton setEnabled:YES];
                             [myIndicator removeFromSuperview];
                         }
                     }else if ([array[0] isKindOfClass:[NSString class]]){
                         
                         [self performSelectorOnMainThread:@selector(pushToTab) withObject:nil waitUntilDone:false];
                         
                         AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Whoops!" andText:array[0] andCancelButton:false forAlertType:AlertFailure andColor:[UIColor darkCSWBlueColor]];
                         [alert setCornerRadius:15];
                         [alert setTextFont:[UIFont sanFranciscoFontWithSize:12]];
                         [alert show];
                         [self.logInButton setEnabled:YES];
                         [myIndicator removeFromSuperview];
                         
                         
                     }
                     
                     
                     
                 }];
    
    
}

-(void) pushToTab{
    [self performSegueWithIdentifier:@"pushToTab" sender:self];
}


@end
