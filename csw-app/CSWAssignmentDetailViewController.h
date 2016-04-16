//
//  CSWAssignmentDetailViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 28/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "CSWManager.h"

@interface CSWAssignmentDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *assignment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextView *assigmentTitleTextView;
@property (weak, nonatomic) IBOutlet UILabel *dueLabel;

@end
