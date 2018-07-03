//
//  CSWGradeBookViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 19/04/16.
//  Copyright © 2016 Matteo Sandrin. All rights reserved.
//

#import "CSWGradeBookViewController.h"

@interface CSWGradeBookViewController ()

@end

@implementation CSWGradeBookViewController

@synthesize grades,class_data;

- (void)viewDidLoad {
    [super viewDidLoad];
    grades = [NSArray array];
    self.title = @"Grades";
    
    self.loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.loadingView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.loadingView];
    [self startActivityIndicator];
    
    [self getGradesData];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 120)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 120)];
    [label setText:[NSString stringWithFormat:@"%@%%",self.class_data[@"cumgrade"]]];
    [label setFont:[UIFont sanFranciscoFontWithSize:45]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor darkCSWBlueColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.tableView.tableHeaderView addSubview:label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getGradesData{
    
    CSWManager *manager = [CSWManager sharedManager];
    
    NSLog(@"classid: %@",class_data);
    
//    NSString *userId = [NSString stringWithFormat:@"%d",manager.userInfo[@"UserId"]];
//    NSString *sectionId = [NSString stringWithFormat:@"%d",class_data[@"Id"]];
//    NSString *periodId = [NSString stringWithFormat:@"%d",class_data[@"markingperiodid"]];
    
    NSString *userId = manager.userInfo[@"UserId"];
    NSString *sectionId = class_data[@"Id"];
    NSString *periodId = class_data[@"markingperiodid"];

    [manager getGradeBookForUserId:userId andSectionId:sectionId andPeriodId:periodId andCompletionBlock:^(NSArray *array) {
        if ([array[0] isKindOfClass:[NSString class]]) {
            NSLog(@"%@",array[0]);
        }else{
            
            NSMutableArray* array_copy = [NSMutableArray arrayWithArray:array];
            
            for (int i = 0; i < array.count; i++) {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                NSLog(@"%@",dict[@"DateDue"]);
                long long due_ticks = [(NSNumber*)dict[@"DateDueTicks"] longLongValue];
                long long due_epoch = (due_ticks - 621355968000000000) / 10000000;
                dict[@"NSDueDate"] = [NSDate dateWithTimeIntervalSinceNow:due_epoch];
                array_copy[i] = dict;
                NSLog(@"%@",dict[@"NSDueDate"]);
                // 1/20/2016 11:59 PM
            }
            
            array = [array_copy sortedArrayUsingFunction:gradeDateSort context:nil];
            
            grades = array;
            [self.tableView reloadData];
            [self stopActivityIndicator];
        }
    }];
    
}

-(void) startActivityIndicator {
    
    ac = [[UIActivityIndicatorView alloc] init];
    [ac setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [ac setColor:[UIColor darkCSWBlueColor]];
    [ac setCenter:CGPointMake(self.loadingView.frame.size.width / 2, (self.loadingView.frame.size.height - 70) / 2)];
    [self.loadingView addSubview:ac];
    [ac startAnimating];
    
}

-(void) stopActivityIndicator{
    [UIView animateWithDuration:0.3 animations:^{
        self.loadingView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return grades.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"gradeCell";
    CSWGradeTableViewCell *cell = (CSWGradeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSWGradeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *cellData = grades[indexPath.row];
    
    [cell setupWithData:cellData];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

NSComparisonResult gradeDateSort(NSDictionary *s1, NSDictionary *s2, void *context) {
    
    NSDate *d1 = s1[@"NSDueDate"];
    NSDate *d2 = s2[@"NSDueDate"];
    
    //    return [d1 compare:d2]; // ascending order
    return [d2 compare:d1]; // descending order
}

@end
