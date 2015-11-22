//
//  CSWClassViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 07/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWClassViewController.h"

@interface CSWClassViewController ()

@end

@implementation CSWClassViewController

@synthesize class_data;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.loadingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.loadingView];
    [self startActivityIndicator];
    
    CSWManager *manager = [CSWManager sharedManager];
    [manager getClassDetailWithId:class_data[@"SectionId"] andCompletion:^(NSArray *array) {
        if (array != nil) {
            if (array.count > 0) {
                if ([array[0] isKindOfClass:[NSString class]]) {
                    NSLog(@"%@",array[0]);
                    [self processErrorWithString:array[0]];
                }else{
                    self.class_data = (NSDictionary*)array[0];
                    [self setupUI];
                    [self stopActivityIndicator];
                }
            }else{
                [self processErrorWithString:@"Oops! No data was found for this class."];
            }
        }else{
            [self processErrorWithString:@"Oops! No data was found for this class."];
        }
        
        
        
        
    }];
    [self setupUI];
    
}

-(void) processErrorWithString:(NSString*)error {
    
    [ac removeFromSuperview];
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.text = error;
    errorLabel.font = [UIFont sanFranciscoFontWithSize:15];
    errorLabel.numberOfLines = 2;
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    [errorLabel setMinimumScaleFactor:0.5];
    [errorLabel setTextColor:[UIColor darkCSWBlueColor]];
    
    CGSize winSize = self.view.frame.size;
    float labelWidth = winSize.width * 0.9f;
    [errorLabel setFrame:CGRectMake((winSize.width-labelWidth)/2, (winSize.height-75)/2, labelWidth, 75)];
    [self.loadingView addSubview:errorLabel];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void) setupUI{
    
    self.title = (NSString*)class_data[@"Identifier"];
    self.titleLabel.text = (NSString*)class_data[@"GroupName"];
    self.teacherLabel.text = (NSString*)class_data[@"Teacher"];
//    self.descriptionTextView.layer.cornerRadius = 15.0;
    
    NSString *htmlString = [NSString stringWithFormat:@"%@",(NSString*)class_data[@"Description"]];
    NSLog(@"desc: %@",htmlString);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont sanFranciscoFontWithSize:20] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor cloudsColor] range:NSMakeRange(0, attributedString.length)];
    self.descriptionTextView.textContainerInset = (UIEdgeInsets){ .left = 15, .right = 15, .top = 20, .bottom = 5 };
    self.descriptionTextView.attributedText = attributedString;
    
    NSLog(@"desc: %@",attributedString);
    
    self.rosterButton.cornerRadius = 10.0f;
    self.rosterButton.shadowHeight = 3.0f;
    self.rosterButton.shadowColor = [UIColor darkCSWBlueColor];
    self.rosterButton.buttonColor = [UIColor lightCSWBlueColor];
    
    [self adjustScrollView];

    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
}

-(void) adjustScrollView{
    float scrollViewHeight = 0;
    for (UIView *view in self.scrollView.subviews){
        if (scrollViewHeight < view.frame.origin.y + view.frame.size.height) scrollViewHeight = view.frame.origin.y + view.frame.size.height;
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollViewHeight);

}

-(void) startActivityIndicator {
    
    ac = [[UIActivityIndicatorView alloc] init];
    [ac setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [ac setColor:[UIColor darkCSWBlueColor]];
    [ac setCenter:CGPointMake(self.loadingView.frame.size.width / 2, (self.loadingView.frame.size.height - 70) / 2)];
    [self.loadingView addSubview:ac];
    [ac startAnimating];
    
}

-(void) stopActivityIndicator{
    [UIView animateWithDuration:0.3 animations:^{
        self.loadingView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CSWRosterViewController *destination = (CSWRosterViewController*)[segue destinationViewController];
    
    destination.classId = [(NSNumber*)class_data[@"Id"] stringValue];
    
}

@end
