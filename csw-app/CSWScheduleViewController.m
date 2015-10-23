//
//  CSWScheduleViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 21/10/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWScheduleViewController.h"

@interface CSWScheduleViewController ()

@end

@implementation CSWScheduleViewController

@synthesize schedule;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    schedule = [NSArray array];
    [self setupUI];
    [self getScheduleForDate:[NSDate date]];
    
}

-(void) getScheduleForDate:(NSDate*)date {
    
    CSWManager *manager = [CSWManager sharedManager];
    [manager getScheduleForDate:date
                 withCompletion:^(NSArray *result){
        
        if (result.count > 1 || result.count == 0) {
            schedule = result;
            [self.tableView reloadData];
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
            
        }
        
        if (result.count == 0) {
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
            [label setText:@"No schedule was found for this date"];
            [label setFont:[UIFont sanFranciscoFontWithSize:15]];
            [label setTextColor:[UIColor darkCSWBlueColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [self.tableView.tableHeaderView addSubview:label];

        }else{
            [UIView animateWithDuration:0.1 animations:^{
                [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 0, 0)];
            } completion:^(BOOL finished) {
                self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
            }];
        }
        
    }];
    
}

-(void) setupUI{
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                              NSFontAttributeName: [UIFont sanFranciscoFontWithSize:20]
                              }];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] init];
    [ac setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [ac setColor:[UIColor darkCSWBlueColor]];
    [ac setCenter:CGPointMake(self.tableView.frame.size.width / 2, 35)];
    scheduleActivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, 70)];
    [scheduleActivityView addSubview:ac];
    self.tableView.tableHeaderView = scheduleActivityView;
    [ac startAnimating];
  
    
}

- (IBAction)daySelectButtonTapped:(id)sender {
    
    NSDateComponents *today_components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:3];
    [components setMonth:9];
    [components setYear:[today_components year]];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    calendar = [NSCalendar currentCalendar];
    components = [[NSDateComponents alloc] init];
    
    [components setDay:5];
    [components setMonth:6];
    [components setYear:[today_components year]+1];
    
    NSDate *endDate = [calendar dateFromComponents:components];
    
    if (currentDate == nil) {
        currentDate = [NSDate date];
    }
    
    [ActionSheetDatePicker showPickerWithTitle:@""
                                datePickerMode:UIDatePickerModeDate
                                  selectedDate:currentDate
                                   minimumDate:startDate
                                   maximumDate:endDate
                                     doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                         
                                         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                         [formatter setDateFormat:@"E, M/d"];
                                         
                                         NSString *stringFromDate = [formatter stringFromDate:(NSDate*)selectedDate];
                                         currentDate = (NSDate*)selectedDate;

                                         [self.daySelectBarButton setTitle:stringFromDate];
                                         [self getScheduleForDate:(NSDate*)selectedDate];
                                     }
                                   cancelBlock:^(ActionSheetDatePicker *picker) {
                                       NSLog(@"cancel");
                                   }
                                        origin:self.view];
    
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
    return schedule.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"scheduleCell";
    CSWScheduleTableViewCell *cell = (CSWScheduleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSWScheduleCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *cellData = schedule[indexPath.row];
    
    [cell setupWithData:cellData];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 170.0f;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
