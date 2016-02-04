//
//  CSWMainTabBarViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 21/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWManager.h"
#import "CSWAssignmentDetailViewController.h"
#import "CSWAssignmentsViewController.h"
#import "CSWDirectorySearchViewController.h"

@interface CSWMainTabBarViewController : UITabBarController <UITabBarControllerDelegate>


@property (nonatomic,strong) UIViewController *selectedController;


@end
