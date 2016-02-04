//
//  CSWSearchPopoverViewController.h
//  csw-app
//
//  Created by Matteo Sandrin on 25/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWSearchPopoverViewController : UIViewController <UIPopoverPresentationControllerDelegate>

{
    int _directory;
    int _grade;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *directorySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gradeSegment;

-(int) getGrade;
-(int) getDirectory;
-(void) setGrade:(int)grade;
-(void) setDirectory:(int)dir;

@end
