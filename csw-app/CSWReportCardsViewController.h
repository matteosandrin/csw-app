//
//  CSWReportCardsViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 22/12/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWManager.h"
#import "CSWReportCardTableViewCell.h"
#import "FlatUIKit.h"
#import "SVModalWebViewController.h"

@interface CSWReportCardsViewController : UITableViewController

{
    bool isLoading;
}

@property (nonatomic,strong) NSArray *reports;

@end
