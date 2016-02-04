//
//  CSWSearchTableViewCell.m
//  csw-app
//
//  Created by Matteo Sandrin on 22/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWSearchTableViewCell.h"

@implementation CSWSearchTableViewCell

- (void)awakeFromNib {
}

-(void) setupWithData:(NSDictionary *)data {
    
    
    
    if ([[data allKeys] containsObject:@"GradYear"]) {
        NSString *gradYear = (NSString*)data[@"GradYear"];
        if (gradYear.length > 0) {
            self.gradYearLabel.text = gradYear;
            
        }
        NSString *gradDisp = (NSString*)data[@"GradeDisplay"];
        if (gradDisp.length > 2) {
            self.gradYearLabel.text = @"";
        }
    }
    
    if ([[data allKeys] containsObject:@"DepartmentDisplay"]){
        NSString *gradYear = (NSString*)data[@"DepartmentDisplay"];
        self.gradYearLabel.text = gradYear;
    }

    
    NSString *last = (NSString*)data[@"LastName"];
    NSString *first = (NSString*)data[@"FirstName"];

    if ([[data allKeys] containsObject:@"Nickname"]) {
        NSString *nick = (NSString*)data[@"Nickname"];
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",nick,last];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",first,last];
    }
    
    
}

-(void) setupImage:(UIImage *)image {
    
    self.userThumbImageView.layer.cornerRadius = 10.0f;
    self.userThumbImageView.layer.masksToBounds = true;
    self.userThumbImageView.layer.shadowRadius = 2;
    self.userThumbImageView.layer.shadowOpacity = 0.5;
    self.userThumbImageView.layer.shadowOffset = CGSizeMake(1, 1);
    self.userThumbImageView.layer.borderColor = [UIColor darkCSWBlueColor].CGColor;
    self.userThumbImageView.layer.borderWidth = 2.0f;
    [self.userThumbImageView setImage:image];
    
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        [self.contentView setBackgroundColor:[UIColor lightCSWBlueColor]];
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor lightCSWBlueColor]];
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
}


@end
