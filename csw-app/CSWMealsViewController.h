//
//  CSWMealsViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 16/04/16.
//  Copyright © 2016 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWManager.h"
#import "CSWReportCardTableViewCell.h"
#import "FlatUIKit.h"
#import "SVModalWebViewController.h"


@interface CSWMealsViewController : UITableViewController

{
    bool isLoading;
}

@property (nonatomic,strong) NSArray *meals;

@end
