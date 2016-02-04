//
//  CSWReportCardTableViewCell.h
//  csw-app
//
//  Created by Matteo Sandrin on 22/12/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@interface CSWReportCardTableViewCell : UITableViewCell

{
    UIActivityIndicatorView *activityIndicator;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *baseView;

-(void) setupWithTitle:(NSString*)title;

@end
