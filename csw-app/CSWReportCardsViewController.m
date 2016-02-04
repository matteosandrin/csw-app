//
//  CSWReportCardsViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 22/12/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWReportCardsViewController.h"

@interface CSWReportCardsViewController ()

@end

@implementation CSWReportCardsViewController

@synthesize reports;

- (void)viewDidLoad {
    reports = [NSArray array];
    [super viewDidLoad];
    [self setupUI];
    [self refresh];
    
}

-(void) setupUI{
    
    self.title = @"Reports";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor cloudsColor],
                              NSFontAttributeName: [UIFont sanFranciscoFontWithSize:20]
                              }];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self setRefreshControlTitle:@"Pull to Refresh"];
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];
    
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
    return reports.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"reportsCell";
    CSWReportCardTableViewCell *cell = (CSWReportCardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSWReportCardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setupWithTitle:(NSString*)reports[indexPath.row][@"performance_description"]];
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (!isLoading) {
        isLoading = true;
        SVModalWebViewController *modal = [[SVModalWebViewController alloc] initWithBlank];
        [self.navigationController presentViewController:modal animated:true completion:nil];
        NSDictionary *report = reports[indexPath.row];
        
        [[CSWManager sharedManager] getReportPdfFileWithReportId:report[@"Id"]
                                                       andUserId:report[@"student_user_id"]
                                                   andSchoolYear:report[@"school_year_label"]
                                              andCompletionBlock:^(NSArray *array) {
                                                  if (array.count > 0) {
                                                      if (![array[0] isKindOfClass:[NSString class]]) {
                                                          NSData *data = (NSData*)array[0];
                                                          [modal loadData:data];
                                                      }else{
                                                          NSLog(@"error: %@",array[0]);
                                                      }
                                                  }
                                                  isLoading = false;
                                              }];

    }
    
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:false];
}

#pragma refresh control

-(void) refresh {
    
    [self.refreshControl beginRefreshing];
    [[CSWManager sharedManager] getReportCardsWithCompletionBlock:^(NSArray *array) {
        
        [self.refreshControl endRefreshing];
        [self setRefreshControlTitle:@"Pull to Refresh"];
        
        if (array.count > 0) {
            if (![array[0] isKindOfClass:[NSString class]]) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 0, 0)];
                } completion:^(BOOL finished) {
                    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
                }];
                
                reports = array;
                [self.tableView reloadData];
            }else{
                self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
                [label setText:array[0]];
                [label setFont:[UIFont sanFranciscoFontWithSize:12]];
                [label setTextColor:[UIColor darkCSWBlueColor]];
                [label setBackgroundColor:[UIColor whiteColor]];
                [label setTextAlignment:NSTextAlignmentCenter];
                [self.tableView.tableHeaderView addSubview:label];
            }
        }else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
            [label setText:@"No reports available"];
            [label setFont:[UIFont sanFranciscoFontWithSize:12]];
            [label setTextColor:[UIColor darkCSWBlueColor]];
            [label setBackgroundColor:[UIColor whiteColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [self.tableView.tableHeaderView addSubview:label];
            reports = [NSArray array];
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
