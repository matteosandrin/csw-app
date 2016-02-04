//
//  CSWDirectorySearchViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 22/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWManager.h"
#import "CSWSearchTableViewCell.h"
#import "CSWSearchPopoverViewController.h"
#import "CSWDetailSearchViewController.h"

@interface CSWDirectorySearchViewController : UITableViewController <UISearchBarDelegate, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate>

{
    UIView *activityView;
    UIView *loadingView;
    CSWSearchPopoverViewController *popoverController;
    int grade;
    int directory;
    int selectedCellId;
    NSTimer* searchTimer;
    BOOL shouldClear;
}

@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (strong, nonatomic) UISearchBar *searchBar;

-(void) clearResults;

@end
