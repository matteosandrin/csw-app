//
//  CSWReportCardTableViewCell.m
//  csw-app
//
//  Created by Matteo Sandrin on 22/12/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWReportCardTableViewCell.h"

@implementation CSWReportCardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void) setupWithTitle:(NSString*)title{
    
    self.titleLabel.text = title;
    self.baseView.layer.cornerRadius = 17.0f;
    self.baseView.layer.shadowRadius = 3;
    self.baseView.layer.shadowOpacity = 0.5;
    self.baseView.layer.shadowOffset = CGSizeMake(1, 1);
    
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
        [self startLoading];
    } else {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self stopLoading];
    }
}

-(void) startLoading{
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    activityIndicator.tintColor = [UIColor lightCSWBlueColor];
    self.titleLabel.alpha = 0;
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
}

-(void) stopLoading{
    
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
    self.titleLabel.alpha = 1;
    
}

@end
