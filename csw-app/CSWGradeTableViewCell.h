//
//  CSWGradeTableViewCell.h
//  csw-app
//
//  Created by Matteo Sandrin on 19/04/16.
//  Copyright © 2016 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWGradeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gradePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeDescriptionLabel;

- (void) setupWithData:(NSDictionary*)data;

@end
