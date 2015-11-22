//
//  CSWAssignmantsTableViewCell.m
//  csw-app
//
//  Created by Matteo Sandrin on 27/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWAssignmentsTableViewCell.h"

@implementation CSWAssignmentsTableViewCell

- (void)awakeFromNib {
    
    self.baseView.layer.cornerRadius = 25.0f;
    self.contentTextView.layer.cornerRadius = 10.0f;
    
    self.baseView.layer.shadowRadius = 5;
    self.baseView.layer.shadowOpacity = 0.5;
    self.baseView.layer.shadowOffset = CGSizeMake(1, 1);
    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped)];
//    
//    singleTap.numberOfTapsRequired = 1;
//    singleTap.numberOfTouchesRequired = 1;
//    singleTap.cancelsTouchesInView = NO;
//    [self.tapView addGestureRecognizer: singleTap];
    
}

-(void) setupWithData:(NSDictionary*)cellData {
    
    NSString *htmlString = (NSString*)cellData[@"short_description"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont sanFranciscoFontWithSize:15] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor cloudsColor] range:NSMakeRange(0, attributedString.length)];
    self.contentTextView.attributedText = attributedString;
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.titleLabel.text = (NSString*)cellData[@"groupname"];
    
   
    
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
