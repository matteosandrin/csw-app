//
//  CSWScheduleTableViewCell.h
//  csw-app
//
//  Created by Matteo Sandrin on 21/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@interface CSWScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *baseCellView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

-(void) setupWithData:(NSDictionary*)cellData;

@end
