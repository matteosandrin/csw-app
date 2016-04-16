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

@synthesize selectedController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBar.items[0] setImage:[[UIImage imageNamed:@"scheduleTabButtonNormal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar.items[0] setSelectedImage:[[UIImage imageNamed:@"scheduleTabButtonSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[0] setTitle:@"Schedule"];
    
    [self.tabBar.items[1] setImage:[[UIImage imageNamed:@"assignmentsTabButtonNormal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar.items[1] setSelectedImage:[[UIImage imageNamed:@"assignmentsTabButtonSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[1] setTitle:@"Homework"];
    
    [self.tabBar.items[2] setImage:[[UIImage imageNamed:@"reportsTabButtonNormal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar.items[2] setSelectedImage:[[UIImage imageNamed:@"reportsTabButtonSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[2] setTitle:@"Reports"];
    
    [self.tabBar.items[3] setImage:[[UIImage imageNamed:@"mealsTabButtonNormal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar.items[3] setSelectedImage:[[UIImage imageNamed:@"mealsTabButtonSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[3] setTitle:@"Meals"];
    
    [self.tabBar.items[4] setImage:[[UIImage imageNamed:@"directoryTabButtonNormal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.tabBar.items[4] setSelectedImage:[[UIImage imageNamed:@"directoryTabButtonSelected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[4] setTitle:@"Directory"];
    
    self.delegate = self;
    selectedController = self.viewControllers[0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    
//    if ([selectedController respondsToSelector:@selector(clearResults)]) {
//        [(CSWDirectorySearchViewController*)selectedController clearResults];
//    }
//    NSLog(@"title: %@",selectedController.title);
//    selectedController = viewController;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
