//
//  CSWAssignmentsViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 24/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWManager.h"
#import "CSWAssignmentsTableViewCell.h"
#import "CSWAssignmentDetailViewController.h"
#import "FlatUIKit.h"
#import "ActionSheetStringPicker.h"

@interface CSWAssignmentsViewController : UITableViewController <UITableViewDelegate>

{
    NSDate *currentDate;
}

@property (nonatomic,strong) NSArray *assignments;
@property (nonatomic,strong) NSString *weekDayDue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dayDueBarButton;

- (IBAction)dueSelectButtonTapped:(id)sender;

@end
