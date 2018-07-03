//
//  CSWGradeBookViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 19/04/16.
//  Copyright © 2016 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSWGradeTableViewCell.h"
#import "CSWManager.h"
#import "FlatUIKit.h"

@interface CSWGradeBookViewController : UITableViewController

{
    UIActivityIndicatorView *ac;
}

@property (nonatomic, strong) NSArray *grades;
@property (nonatomic, strong) NSDictionary *class_data;
@property (nonatomic, strong) UIView *loadingView;

@end
