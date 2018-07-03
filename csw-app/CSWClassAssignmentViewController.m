//
//  CSWAssignmentsViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 24/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWClassAssignmentViewController.h"

@interface CSWClassAssignmentViewController ()

@end

@implementation CSWClassAssignmentViewController

@synthesize assignments;

- (void)viewDidLoad {
    
    isOnlyActive = true;
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    assignments = [NSArray array];
    [self setupUI];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    [self refresh];
    
}

-(void) setupUI {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                              NSFontAttributeName: [UIFont sanFranciscoFontWithSize:20]
                              }];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                           NSFontAttributeName: [UIFont sanFranciscoFontWithSize:16]} forState:UIControlStateNormal];
    
    [self.isOnlyActiveBarButton setTitleTextAttributes:@{
                                                   NSFontAttributeName : [UIFont sanFranciscoFontWithSize:17],
                                                   NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                   }
                                        forState:UIControlStateNormal];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back  "
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    //    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] init];
    //    [ac setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //    [ac setColor:[UIColor darkCSWBlueColor]];
    //    [ac setCenter:CGPointMake(self.tableView.frame.size.width / 2, 35)];
    //    UIView *scheduleActivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, 70)];
    //    [scheduleActivityView addSubview:ac];
    //    self.tableView.tableHeaderView = scheduleActivityView;
    //    [ac startAnimating];
    
    //    NSCalendar* cal = [NSCalendar currentCalendar];
    //    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    //
    //    NSDictionary *weekdays = @{
    //                                @1:@"Sunday",
    //                                @2:@"Monday",
    //                                @3:@"Tuesday",
    //                                @4:@"Wednesday",
    //                                @5:@"Thursday",
    //                                @6:@"Friday",
    //                                @7:@"Saturday"
    //                               };
    //
    //    int todayWeek = [comp weekday];
    //    int tomorrowWeek = todayWeek;
    //
    //    if (todayWeek > 5 || todayWeek == 1) {
    //        tomorrowWeek = 2;
    //    }else{
    //        tomorrowWeek++;
    //    }
    //
    //    NSLog(@"tomorrowWeek: %d todayWeek: %d",tomorrowWeek,todayWeek);
    //
    //    self.weekDayDue = weekdays[[NSNumber numberWithInt:tomorrowWeek]];
    self.title = @"Homework";
    //    self.title = [NSString stringWithFormat:@"Due %@",self.weekDayDue];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self setRefreshControlTitle:@"Pull to Refresh"];
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];
    
    
}

- (void) showSelector:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Homework" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Active" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Active"];
        isOnlyActive = true;
        [self refresh];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Previous" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[self navigationItem] rightBarButtonItem] setTitle:@"Previous"];
        isOnlyActive = false;
        [self refresh];
    }]];

    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return assignments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"assignmentsCell";
    CSWAssignmentsTableViewCell *cell = (CSWAssignmentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSWAssignmentsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setupWithSingleClassData:(NSDictionary*)assignments[indexPath.row]];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"pushToAssignment" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    long index = self.tableView.indexPathForSelectedRow.row;
    NSMutableDictionary *newData = [NSMutableDictionary dictionaryWithDictionary:assignments[index]];
    
    newData[@"short_description"] = newData[@"AssignmentDescription"];
    newData[@"long_description"] = newData[@"AssignmentLongDescription"];
    newData[@"groupname"] = self.className;
//    newData[@"date_dueTicks"] = newData[@"DateDue"];
    newData[@"assignment_status"] = newData[@"AssignmentStatus"];
    newData[@"assignment_index_id"] = newData[@"AssignmentIndexId"];
    
    
    CSWAssignmentDetailViewController *destination = (CSWAssignmentDetailViewController*)[segue destinationViewController];
    
    destination.assignment = newData;
    
}

#pragma refresh control

-(void) refresh {
    
    [self.refreshControl beginRefreshing];
    CSWManager *manager = [CSWManager sharedManager];
    //    if (currentDate == nil) {
    //        currentDate = [NSDate date];
    //    }
    [manager getAssignmentsSummaryForClass:self.classId onlyActive:isOnlyActive andCompletionBlock:^(NSArray *array) {
        
        [self.refreshControl endRefreshing];
        [self setRefreshControlTitle:@"Pull to Refresh"];
        NSLog(@"%@",array);
        if (array.count > 0) {
            if ([array[0] isKindOfClass:[NSString class]]) {
                self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
                [label setText:array[0]];
                [label setFont:[UIFont sanFranciscoFontWithSize:12]];
                [label setTextColor:[UIColor darkCSWBlueColor]];
                [label setBackgroundColor:[UIColor whiteColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [self.tableView.tableHeaderView addSubview:label];
            }else{
                
                [UIView animateWithDuration:0.1 animations:^{
                    [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 0, 0)];
                } completion:^(BOOL finished) {
                    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
                }];
                

//                array = [[array reverseObjectEnumerator] allObjects];
                
                
                NSMutableArray* array_copy = [NSMutableArray arrayWithArray:array];
                
                for (int i = 0; i < array.count; i++) {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"M/d/yyyy"];
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                    NSLog(@"%@",dict[@"DueDate"]);
                    dict[@"NSDueDate"] = [formatter dateFromString:dict[@"DueDate"]];
                    array_copy[i] = dict;
                    NSLog(@"%@",dict[@"NSDueDate"]);
                    // 1/20/2016 11:59 PM
                }
                
                array = [array_copy sortedArrayUsingFunction:dateSort context:nil];

                
                assignments = array;
                [self.tableView reloadData];
            }
        }else{
            
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
            
            [label setText:[NSString stringWithFormat:@"No homework found"]];
            [label setFont:[UIFont sanFranciscoFontWithSize:12]];
            [label setTextColor:[UIColor darkCSWBlueColor]];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [self.tableView.tableHeaderView addSubview:label];
            assignments = [NSArray array];
            [self.tableView reloadData];
        }
        
        
    }];
    
    [self setRefreshControlTitle:@"Refreshing..."];
    
}

NSComparisonResult dateSort(NSDictionary *s1, NSDictionary *s2, void *context) {
    
    NSDate *d1 = s1[@"NSDueDate"];
    NSDate *d2 = s2[@"NSDueDate"];
    
//    return [d1 compare:d2]; // ascending order
    return [d2 compare:d1]; // descending order
}

-(void) setRefreshControlTitle:(NSString*)s {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:s];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor lightCSWBlueColor] range:NSMakeRange(0, [s length])];
    self.refreshControl.attributedTitle = title;
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];
    [self.refreshControl setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
}

@end
