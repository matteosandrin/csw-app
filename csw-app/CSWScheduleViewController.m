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
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    [self refresh];
    
}

-(void) getScheduleForDate:(NSDate*)date {
    
    CSWManager *manager = [CSWManager sharedManager];
    [manager getScheduleForDate:date
                 withCompletion:^(NSArray *result){

         [self.refreshControl endRefreshing];
         [self setRefreshControlTitle:@"Pull to Refresh"];
        
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
             [label setBackgroundColor:[UIColor whiteColor]];
             [label setTextAlignment:NSTextAlignmentCenter];
             [self.tableView.tableHeaderView addSubview:label];
             
         }else{
             
             if ([result[0] isKindOfClass:[NSString class]]) {
                 self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
                 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
                 [label setText:result[0]];
                 [label setFont:[UIFont sanFranciscoFontWithSize:12]];
                 [label setTextColor:[UIColor darkCSWBlueColor]];
                 [label setTextAlignment:NSTextAlignmentCenter];
                 [label setBackgroundColor:[UIColor whiteColor]];
                 [self.tableView.tableHeaderView addSubview:label];
             }else{
                 [UIView animateWithDuration:0.1 animations:^{
//                     [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 0, 0)];
                     [self.tableView setTableHeaderView:nil];
                 } completion:^(BOOL finished) {
                     self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
                 }];
             }
             
         }
                     
        
        
    }];
    
}

-(void) setupUI{
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                              NSFontAttributeName: [UIFont sanFranciscoFontWithSize:20]
                              }];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                           NSFontAttributeName: [UIFont sanFranciscoFontWithSize:17]} forState:UIControlStateNormal];
    
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
//    scheduleActivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, 70)];
//    [scheduleActivityView addSubview:ac];
//    self.tableView.tableHeaderView = scheduleActivityView;
//    [ac startAnimating];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh setTintColor:[UIColor lightCSWBlueColor]];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self setRefreshControlTitle:@"Pull to Refresh"];
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];

    
    [self.daySelectBarButton setTitleTextAttributes:@{
                                                      NSFontAttributeName : [UIFont sanFranciscoFontWithSize:15],
                                                      NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                      }
                              forState:UIControlStateNormal];
    
  
    
}

-(void) refresh {
    
    [self.refreshControl beginRefreshing];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    if (currentDate == nil) {
        [self getScheduleForDate:[NSDate date]];
    }else{
        [self getScheduleForDate:currentDate];
    }
    [self setRefreshControlTitle:@"Refreshing..."];
    
}

-(void) setRefreshControlTitle:(NSString*)s {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:s];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor lightCSWBlueColor] range:NSMakeRange(0, [s length])];
    self.refreshControl.attributedTitle = title;
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];
    [self.refreshControl setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];

    
}

- (IBAction)daySelectButtonTapped:(id)sender {
    
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
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE, MMMM d"];
        NSString *stringFromDate = [formatter stringFromDate:date];
        [rows addObject:stringFromDate];
        dates[stringFromDate] = date;
        if ( fabs(stamp - currentDate.timeIntervalSince1970) < stampDiff ) {
            stampDiff = fabs(stamp - currentDate.timeIntervalSince1970);
            currentRow = i;
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
                                NSString *stringFromDate = [formatter stringFromDate:currentDate];

                                [self.daySelectBarButton setTitle:stringFromDate];
                                [self refresh];
                                
                            }
                          cancelBlock:nil
                               origin:self.view];
    [picker setTapDismissAction:TapActionCancel];
    [picker addCustomButtonWithTitle:@"Today" actionBlock:^{
        [self.daySelectBarButton setTitle:@"Today"];
        currentDate = todayDate;
        [self getScheduleForDate:todayDate];
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


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:@selector(segue) withObject:nil afterDelay:0.1];
}

-(void) segue {
    [self performSegueWithIdentifier:@"pushToClass" sender:self.navigationController];
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
 
     if ([segue.identifier isEqual:@"pushToClass"]) {
         CSWClassViewController *destination = (CSWClassViewController*)[segue destinationViewController];
         
         long index = self.tableView.indexPathForSelectedRow.row;
         NSDictionary *data = schedule[index];
         destination.class_data = data;
         
     }
}


@end
