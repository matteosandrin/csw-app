//
//  CSWRosterTableViewCell.m
//  csw-app
//
//  Created by Matteo Sandrin on 17/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWRosterTableViewCell.h"

@implementation CSWRosterTableViewCell

- (void)awakeFromNib {
}

-(void) setupWithData:(NSDictionary *)data {
    
    NSString *gradYear = (NSString*)data[@"gradYear"];
    NSString *teacherType = (NSString*)data[@"teacherType"];
    
    if ([teacherType isMemberOfClass:[NSNull class]]) {
        
        if ([gradYear isMemberOfClass:[NSNull class]]) {
            self.gradYearLabel.text = @"";
        }else{
            self.gradYearLabel.text = gradYear;
        }
        
    }else{
        self.gradYearLabel.text = teacherType;
    }
    
    NSString *nick = (NSString*)data[@"nickName"];
    NSString *last = (NSString*)data[@"lastName"];
    NSString *name = (NSString*)data[@"name"];
    
//    NSLog(@"%@ %@ %@",nick,last,name);
    
//    if ([nick isMemberOfClass:[NSString class]] ) {
        if ([nick isMemberOfClass:[NSNull class]]) {
            self.nameLabel.text = name;
        }else{
            self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",nick,last];
        }
//    }
    
    
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
        [self setBackgroundColor:[UIColor lightCSWBlueColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selected) {
        [self setBackgroundColor:[UIColor lightCSWBlueColor]];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
