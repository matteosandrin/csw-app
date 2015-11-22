//
//  CSWRosterTableViewCell.h
//  csw-app
//
//  Created by Matteo Sandrin on 17/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "CSWManager.h"
#import <QuartzCore/CALayer.h>

@interface CSWRosterTableViewCell : UITableViewCell

{
    BOOL isThumbDownloaded;
}

@property (weak, nonatomic) IBOutlet UIImageView *userThumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradYearLabel;
@property (strong,nonatomic) NSString *image_url;


-(void) setupWithData:(NSDictionary*)data;
-(void) setupImage:(UIImage*)image;

@end
