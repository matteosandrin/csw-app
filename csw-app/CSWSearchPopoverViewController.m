//
//  CSWSearchPopoverViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 25/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWSearchPopoverViewController.h"

@interface CSWSearchPopoverViewController ()

@end

@implementation CSWSearchPopoverViewController

-(id) init {
    
    if (self == [super init]) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.delegate = self;
    }
    return self;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.gradeSegment setSelectedSegmentIndex:_grade % 8];
    
    switch (_directory) {
        case 851:
            [self.directorySegment setSelectedSegmentIndex:0];
            break;
        case 1259:
            [self.directorySegment setSelectedSegmentIndex:1];
            break;
    }
    [self.directorySegment addTarget:self
                              action:@selector(directorySegmentedValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self directorySegmentedValueChanged:nil];

}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setGrade:(int)grade {
    
    _grade = grade;
    
}

- (void) setDirectory:(int)dir {
    
    _directory = dir;
    
}

-(int) getGrade{
    
    int grade = self.gradeSegment.selectedSegmentIndex + 8;
    
    if (grade < 9 || ![self.gradeSegment isEnabled]) {
        grade = 0;
    }
    
    return grade;
    
}

-(int) getDirectory{

    int dir = self.directorySegment.selectedSegmentIndex;
    
    switch (dir) {
        case 0:
            return 851;
            break;
        case 1:
            return 1259;
            break;
    }
    return 851;
}

-(void) directorySegmentedValueChanged:(id)sender {
    
    switch (self.directorySegment.selectedSegmentIndex) {
        case 0:
            [self.gradeSegment setEnabled:true];
            break;
        case 1:
            [self.gradeSegment setEnabled:false];
            break;
    }
    
}


@end
