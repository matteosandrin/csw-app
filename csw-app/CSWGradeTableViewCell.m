//
//  CSWGradeTableViewCell.m
//  csw-app
//
//  Created by Matteo Sandrin on 19/04/16.
//  Copyright © 2016 Matteo Sandrin. All rights reserved.
//

#import "CSWGradeTableViewCell.h"

@implementation CSWGradeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setupWithData:(NSDictionary *)data {
    
    NSString *description = data[@"Assignment"];
    NSString *maxPoints = data[@"MaxPoints"];
    NSString *points = data[@"Points"];
    
    self.gradeDescriptionLabel.text = description;
    self.gradePointsLabel.text = [NSString stringWithFormat:@"%@/%@",points,maxPoints];
    
}

@end
