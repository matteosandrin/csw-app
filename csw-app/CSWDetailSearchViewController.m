//
//  CSWDetailSearchViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 26/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWDetailSearchViewController.h"

@interface CSWDetailSearchViewController ()

@end

@implementation CSWDetailSearchViewController

@synthesize data;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    NSString *id_num;
    if ([[data allKeys] containsObject:@"UserId"]) {
        id_num = (NSString*)data[@"UserId"];
    }else if ([[data allKeys] containsObject:@"Id"]){
        id_num = (NSString*)data[@"Id"];
    }else if ([[data allKeys] containsObject:@"UserID"]){
        id_num = (NSString*)data[@"UserID"];
    }
    NSLog(@"%f",self.imageView.frame.size.width);
    
    [[CSWManager sharedManager] getPersonWithId:id_num andCompletionBlock:^(NSDictionary *json) {
        if (![[json allKeys] containsObject:@"error"]) {
            [self stopActivityIndicator];
            [self setupLabelsWithData:json];
        }else{
            [self processErrorWithString:json[@"error"]];
        }
    }];
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupUI{
    
    loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    [loadingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:loadingView];
    [self startActivityIndicator];
    self.imageView.layer.cornerRadius = self.view.frame.size.width/4;
    self.imageView.image = self.profilePic;
    self.imageView.layer.masksToBounds = true;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 3.0f;
    [self.imageView setUserInteractionEnabled:true];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicTapped:)];
    [self.imageView addGestureRecognizer:tap];
    
}

-(void) setupLabelsWithData:(NSDictionary*)d {
    
    self.nameLabel.text = @"--";
    self.gradYearLabel.text = @"--";
    self.statusLabel.text = @"--";
    self.emailLabel.text = @"--";
    self.dateBirthLabel.text = @"";

    NSString *last = (NSString*)d[@"LastName"];
    NSString *first = (NSString*)d[@"FirstName"];
    
    if ([[d allKeys] containsObject:@"NickName"] && [(NSString*)d[@"NickName"] length] > 0) {
        NSString *nick = (NSString*)d[@"NickName"];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ \"%@\" %@",first,nick,last];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",first,last];
    }
    

    if ([d[@"StudentInfo"][@"GradYear"] length] > 0) {
        self.gradYearLabel.text = d[@"StudentInfo"][@"GradYear"];
    }
    
    if ([[data allKeys] containsObject:@"DepartmentDisplay"]){
        NSString *gradYear = (NSString*)data[@"DepartmentDisplay"];
        self.gradYearLabel.text = gradYear;
    }
    
    if ([[d allKeys] containsObject:@"Email"]){
        NSString *email = (NSString*)d[@"Email"];
        self.emailLabel.text = [email lowercaseString];
    }
    
    if ([[d allKeys] containsObject:@"BoardingOrDay"]){
        
        NSDictionary *bdkeys = @{
                                 @"B":@"Boarding Student",
                                 @"D":@"Day Student",
                                 };
        
        NSString *status = (NSString*)d[@"BoardingOrDay"];
        self.statusLabel.text = bdkeys[status];
    }
    
    if ([[d allKeys] containsObject:@"BirthDate"] && ![d[@"BirthDate"] isKindOfClass:[NSNull class]]){
        
        NSString *birthString = (NSString*)d[@"BirthDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yyyy h:mm a"];
        NSDate *birthDate = [formatter dateFromString:birthString];
        [formatter setDateFormat:@"d MMMM yyyy"];
        self.dateBirthLabel.text = [formatter stringFromDate:birthDate];
        
    }
    
//    UIView *horizRule = [[UIView alloc] initWithFrame:CGRectMake(0, self.nameLabel.frame.origin.y-3 , self.view.frame.size.width, 3)];
//    [horizRule setBackgroundColor:[UIColor darkCSWBlueColor]];
//    [self.nameLabel addSubview:horizRule];
    
    
}

-(void) processErrorWithString:(NSString*)error {
    
    loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    [loadingView setBackgroundColor:[UIColor whiteColor]];
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.text = error;
    errorLabel.font = [UIFont sanFranciscoFontWithSize:15];
    errorLabel.numberOfLines = 2;
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    [errorLabel setMinimumScaleFactor:0.5];
    [errorLabel setTextColor:[UIColor darkCSWBlueColor]];
    
    CGSize winSize = self.view.frame.size;
    float labelWidth = winSize.width * 0.9f;
    [errorLabel setFrame:CGRectMake((winSize.width-labelWidth)/2, (winSize.height)/2-90, labelWidth, 75)];
    [loadingView addSubview:errorLabel];
    [self.view addSubview:loadingView];
    
}

-(void) startActivityIndicator {
    
    ac = [[UIActivityIndicatorView alloc] init];
    [ac setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [ac setColor:[UIColor darkCSWBlueColor]];
    [ac setCenter:CGPointMake(loadingView.frame.size.width / 2, (loadingView.frame.size.height - 70) / 2)];
    [loadingView addSubview:ac];
    [ac startAnimating];
    
}

-(void) stopActivityIndicator{
    [UIView animateWithDuration:0.3 animations:^{
        loadingView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
    }];
    
}

-(void) profilePicTapped:(id)sender {
    
    NSArray *browserPhotos = @[[IDMPhoto photoWithImage:self.profilePic]];
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:browserPhotos animatedFromView:nil];
    browser.delegate = self;
    NSLog(@"before: %f",self.imageView.superview.frame.origin.y);
    [self.navigationController presentViewController:browser animated:YES completion:nil];
    
}

-(void) photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index{
    NSLog(@"after: %f",self.imageView.superview.frame.origin.y);
    
}

-(void) photoBrowser:(IDMPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)index{
    NSLog(@"about to: %f",self.imageView.superview.frame.origin.y);
    if (self.imageView.superview.frame.origin.y < 64) {
        [self.view setNeedsUpdateConstraints];
    }
}


@end
