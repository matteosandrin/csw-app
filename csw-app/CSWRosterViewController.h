//
//  CSWRosterViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 16/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWManager.h"
#import "CSWRosterTableViewCell.h"

@interface CSWRosterViewController : UITableViewController

{
    UIView *activityView;
}

@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSString *classId;

@end
