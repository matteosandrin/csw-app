//
//  CSWClassViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 07/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "CSWManager.h"
#import "CSWRosterViewController.h"
#import "CSWGradeBookViewController.h"
#import "CSWClassAssignmentViewController.h"

#define lorem @"Lorem ipsum dolor sit amet, mel no inani convenire complectitur. Aeterno qualisque voluptatum cu est, iudico euismod honestatis an quo, cu usu meis harum corrumpit. Cum et alia melius oblique, ut ceteros intellegat sea. Oporteat sententiae sadipscing et sit."

@interface CSWClassViewController : UIViewController

{
    UIActivityIndicatorView *ac;
    BOOL hasGrade;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableDictionary *class_data;
@property (nonatomic,strong) UIView *loadingView;
@property (weak, nonatomic) IBOutlet FUIButton *rosterButton;
@property (weak, nonatomic) IBOutlet FUIButton *gradesButton;
@property (weak, nonatomic) IBOutlet FUIButton *homeworkButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideGradesConstraint;


@end
