//
//  CSWAssignmentDetailViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 28/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWAssignmentDetailViewController.h"

@interface CSWAssignmentDetailViewController ()

@end

@implementation CSWAssignmentDetailViewController

@synthesize assignment;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"data: %@",assignment);
    [self setupUI];
    
}

-(void) setupUI {
    
    self.title = @"Assignment";
//    [self.scrollView setContentSize:CGSizeMake(320, 1000)];
//    self.contentTextView.layer.cornerRadius = 15.0;
    
    NSString *htmlString = [NSString stringWithFormat:@"%@",(NSString*)assignment[@"short_description"]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont sanFranciscoFontWithSize:20] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkCSWBlueColor] range:NSMakeRange(0, attributedString.length)];
    self.assigmentTitleTextView.attributedText = attributedString;
    self.assigmentTitleTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    htmlString = [NSString stringWithFormat:@"%@",(NSString*)assignment[@"long_description"]];
//    htmlString = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed fringilla egestas tortor, id lobortis lacus volutpat sed. Sed sagittis eu nisl sed aliquam. Nam vulputate ac nisi ut rutrum. Aenean ut magna in sem cursus molestie in id est. Cras facilisis faucibus nunc, non tincidunt nisl laoreet et. Integer feugiat lectus elit, ac sollicitudin urna vehicula pellentesque. Mauris id lacinia dolor. Aliquam cursus eleifend malesuada. Praesent id enim nulla. Nulla vel lectus nec ante bibendum convallis sit amet eu lectus. Donec quis tempus metus. Praesent fringilla urna velit, ut cursus metus bibendum id. Interdum et malesuada fames ac ante ipsum primis in faucibus.";
    
    attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont sanFranciscoFontWithSize:15] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor cloudsColor] range:NSMakeRange(0, attributedString.length)];
    self.contentTextView.attributedText = attributedString;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    if ([htmlString isEqualToString:@""] || [htmlString isEqualToString:@"<null>"]) {
//        [self.contentTextView removeFromSuperview];
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, 0)];
        [self.contentTextView setBackgroundColor:[UIColor clearColor]];
        [self.assigmentTitleTextView setBackgroundColor:[UIColor darkCSWBlueColor]];
        
        NSString *htmlString = [NSString stringWithFormat:@"%@",(NSString*)assignment[@"short_description"]];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont sanFranciscoFontWithSize:20] range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor cloudsColor] range:NSMakeRange(0, attributedString.length)];
        self.assigmentTitleTextView.attributedText = attributedString;
        
    }
    
    self.titleLabel.text = (NSString*)assignment[@"groupname"];
    
    long long due_ticks = [(NSNumber*)assignment[@"date_dueTicks"] longLongValue];
    long long due_epoch = (due_ticks - 621355968000000000) / 10000000;
    
    NSDate *dueDate = [NSDate dateWithTimeIntervalSince1970:due_epoch];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [formatter setDateFormat:@"EEEE MM/dd"];
    
    NSString *dueString = [NSString stringWithFormat:@"Due on %@ at ",[formatter stringFromDate:dueDate]];
    [formatter setDateFormat:@"HH:mm a"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    dueString = [dueString stringByAppendingString:[formatter stringFromDate:dueDate]];
    
    self.dueLabel.text = dueString;
    
    NSLog(@"dueTicks: %@",dueDate);
    
    UIBarButtonItem *statusButton;
    
    switch ([assignment[@"assignment_status"] intValue]) {
        case 0:
            statusButton =
            [[UIBarButtonItem alloc] initWithTitle:@"In Progress"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showSelector)];
            break;
        case 1:
            statusButton =
            [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showSelector)];
            break;
        case 2:
            statusButton =
            [[UIBarButtonItem alloc] initWithTitle:@"Overdue"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showSelector)];
            break;
        case -1:
            statusButton =
            [[UIBarButtonItem alloc] initWithTitle:@"To-do"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showSelector)];
            break;
        case 4:
            statusButton =
            [[UIBarButtonItem alloc] initWithTitle:@"Graded"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(showSelector)];
            break;
        default:
            break;
    }
    [statusButton setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                                          NSFontAttributeName: [UIFont sanFranciscoFontWithSize:13]
                                           } forState:UIControlStateNormal];
    [[self navigationItem] setRightBarButtonItem:statusButton];
    
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in self.scrollView.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
    float scrollViewHeight = 0;
    for (UIView *view in self.scrollView.subviews){
        if (scrollViewHeight < view.frame.origin.y + view.frame.size.height) scrollViewHeight = view.frame.origin.y + view.frame.size.height;
    }
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollViewHeight);
    NSLog(@"%f",scrollViewHeight);
    
}

-(void) showSelector{
    
    CSWManager *manager = [CSWManager sharedManager];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Assignment Status" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Done"];
        [manager setAssignmentStatusWithId:assignment[@"assignment_index_id"] andStatusCode:1];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"In Progress" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"In Progress"];
        [manager setAssignmentStatusWithId:assignment[@"assignment_index_id"] andStatusCode:0];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"To-do" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"To-do"];
        [manager setAssignmentStatusWithId:assignment[@"assignment_index_id"] andStatusCode:-1];
    }]];
    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Overdue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[[self navigationItem] rightBarButtonItem] setTitle:@"Overdue"];
//        [manager setAssignmentStatusWithId:assignment[@"assignment_index_id"] andStatusCode:2];
//    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
