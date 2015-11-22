//
//  CSWMainTabBarViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 21/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWMainTabBarViewController.h"

@interface CSWMainTabBarViewController ()

@end

@implementation CSWMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar.items[0] setImage:[[UIImage imageNamed:@"scheduleTabButtonNormal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar.items[0] setSelectedImage:[[UIImage imageNamed:@"scheduleTabButtonSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[0] setTitle:@"Schedule"];
    
    [self.tabBar.items[1] setImage:[[UIImage imageNamed:@"assignmentsTabButtonNormal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar.items[1] setSelectedImage:[[UIImage imageNamed:@"assignmentsTabButtonSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[1] setTitle:@"Homework"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
