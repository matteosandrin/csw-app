//
//  CSWScheduleViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 21/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWManager.h"
#import "CSWScheduleTableViewCell.h"
#import "FlatUIKit.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "CSWClassViewController.h"

@interface CSWScheduleViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource>

{
    UIView *scheduleActivityView;
    NSDate *currentDate;
}

- (IBAction)daySelectButtonTapped:(id)sender;

@property (nonatomic,strong) NSMutableArray *schedule;
//@property (nonatomic,strong) NSArray *gradesInfo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *daySelectBarButton;

@end
