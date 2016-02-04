//
//  CSWDetailSearchViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 26/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "CSWManager.h"
#import "IDMPhoto.h"
#import "IDMPhotoBrowser.h"

@interface CSWDetailSearchViewController : UIViewController <IDMPhotoBrowserDelegate>

{
    UIView *loadingView;
    UIActivityIndicatorView *ac;
}

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) UIImage *profilePic;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateBirthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageConstraint;


@end
