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

@interface CSWClassAssignmentViewController : UITableViewController <UITableViewDelegate>

{
    BOOL isOnlyActive;
}
- (IBAction)showSelector:(id)sender;

@property (nonatomic,strong) NSArray *assignments;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *isOnlyActiveBarButton;
@property (strong, nonatomic) NSString *classId;
@property (strong, nonatomic) NSString *className;

@end
