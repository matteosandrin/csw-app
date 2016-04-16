//
//  CSWAssignmentsViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 24/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWAssignmentsViewController.h"

@interface CSWAssignmentsViewController ()

@end

@implementation CSWAssignmentsViewController

@synthesize assignments;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    assignments = [NSArray array];
    [self initCurrentDate];
    [self setupUI];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    [self refresh];
    
}

-(void) initCurrentDate {
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:(NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay) fromDate:[NSDate date]];
//    NSLog(@"hour: %ld",(long)comp.hour);
    switch ([comp weekday]) {
        case 7:
            currentDate = [[NSDate date] dateByAddingTimeInterval:2*60*60*24];
            break;
        case 1:
            currentDate = [[NSDate date] dateByAddingTimeInterval:60*60*24];
            break;
            
        default:
            currentDate = [NSDate date];
            if ((comp.hour >= 14 && comp.minute >= 30) || comp.hour >= 15) {
                currentDate = [[NSDate date] dateByAddingTimeInterval:60*60*24];
            }
            break;
    }
    
//    NSLog(@"currentDate: %@",currentDate);
    
}

-(void) setupUI {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                              NSFontAttributeName: [UIFont sanFranciscoFontWithSize:20]
                              }];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                           NSFontAttributeName: [UIFont sanFranciscoFontWithSize:17]} forState:UIControlStateNormal];
    
    [self.dayDueBarButton setTitleTextAttributes:@{
                                                      NSFontAttributeName : [UIFont sanFranciscoFontWithSize:11],
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E, M/d"];
    NSString *stringFromDate = [NSString stringWithFormat:@"Due %@",[formatter stringFromDate:currentDate]];
    
    [self.dayDueBarButton setTitle:stringFromDate];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self setRefreshControlTitle:@"Pull to Refresh"];
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];

    
}

- (IBAction)dueSelectButtonTapped:(id)sender {
    
    if (currentDate == nil) {
        currentDate = [NSDate date];
    }
    
    NSDate *todayDate = [NSDate date];
    
    int startStamp = todayDate.timeIntervalSince1970;
    NSMutableArray *rows = [NSMutableArray array];
    NSMutableDictionary *dates = [NSMutableDictionary dictionary];
    int currentRow = 0;
    int stampDiff = startStamp;
    
    for (int i = 0; i <= 30; i++) {
        
        int stamp = startStamp + i*24*60*60;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
        
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
        
        if ([comp weekday] != 7 && [comp weekday] != 1) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEEE, MMMM d"];
            NSString *stringFromDate = [NSString stringWithFormat:@"Due on %@",[formatter stringFromDate:date]];
            [rows addObject:stringFromDate];
            dates[stringFromDate] = date;
            if ( fabs(stamp - currentDate.timeIntervalSince1970) < stampDiff ) {
                stampDiff = fabs(stamp - currentDate.timeIntervalSince1970);
                currentRow = [rows indexOfObject:stringFromDate];
            }
        }
        
    }
    
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]
                                       initWithTitle:@""
                                       rows:rows
                                       initialSelection:currentRow
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                           [formatter setDateFormat:@"E, M/d"];
                                           
                                           currentDate = (NSDate*)dates[(NSString*)selectedValue];
                                           NSString *stringFromDate = [NSString stringWithFormat:@"Due %@",[formatter stringFromDate:currentDate]];
                                           
                                           [self.dayDueBarButton setTitle:stringFromDate];
                                           [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
                                           [self refresh];

                                           
                                       }
                                       cancelBlock:nil
                                       origin:self.view];
    [picker setTapDismissAction:TapActionCancel];
    [picker addCustomButtonWithTitle:@"Today" actionBlock:^{
//        [self.daySelectBarButton setTitle:@"Today"];
        currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"E, M/d"];
        NSString *stringFromDate = [NSString stringWithFormat:@"Due %@",[formatter stringFromDate:currentDate]];
        [self.dayDueBarButton setTitle:stringFromDate];
//        NSLog(@"%f",self.refreshControl.frame.size.height);
        [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
        [self refresh];
    }];
    
    NSMutableParagraphStyle *labelParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    labelParagraphStyle.alignment = NSTextAlignmentCenter;
    
    picker.pickerBackgroundColor = [UIColor lightCSWBlueColor];
    picker.pickerTextAttributes = @{
                                    NSFontAttributeName : [UIFont sanFranciscoFontWithSize:20],
                                    NSForegroundColorAttributeName : [UIColor cloudsColor],
                                    NSParagraphStyleAttributeName : labelParagraphStyle
                                    };
    picker.toolbar.translucent = NO;
//    [picker.toolbar setBarTintColor:[UIColor darkCSWBlueColor]];
//    [picker.toolbar setBackgroundColor:[UIColor darkCSWBlueColor]];
    
    [picker showActionSheetPicker];
    
    [picker.toolbar setBarTintColor:[UIColor darkCSWBlueColor]];
    [picker.toolbar setBackgroundColor:[UIColor darkCSWBlueColor]];
    
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

    [cell setupWithData:(NSDictionary*)assignments[indexPath.row]];
    
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
    
    CSWAssignmentDetailViewController *destination = (CSWAssignmentDetailViewController*)[segue destinationViewController];
    
    long index = self.tableView.indexPathForSelectedRow.row;
    NSDictionary *data = assignments[index];
    destination.assignment = data;
    
}

#pragma refresh control

-(void) refresh {
    
    [self.refreshControl beginRefreshing];
    CSWManager *manager = [CSWManager sharedManager];
//    if (currentDate == nil) {
//        currentDate = [NSDate date];
//    }
    [manager getAssignmentsSummaryForDueDate:currentDate andSearchMode:1 withCompletion:^  (NSArray *array) {
        
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
                
                assignments = array;
                [self.tableView reloadData];
            }
        }else{
            
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEEE"];
            
            [label setText:[NSString stringWithFormat:@"No homework due %@",[formatter stringFromDate:currentDate]]];
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

-(void) setRefreshControlTitle:(NSString*)s {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:s];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor lightCSWBlueColor] range:NSMakeRange(0, [s length])];
    self.refreshControl.attributedTitle = title;
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];
    [self.refreshControl setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
}


@end
