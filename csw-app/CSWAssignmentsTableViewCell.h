//
//  CSWAssignmantsTableViewCell.h
//  csw-app
//
//  Created by Matteo Sandrin on 27/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@interface CSWAssignmentsTableViewCell : UITableViewCell

-(void) setupWithData:(NSDictionary*)cellData;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *tapView;

@end
