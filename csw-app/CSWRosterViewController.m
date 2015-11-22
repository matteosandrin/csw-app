//
//  CSWRosterViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 16/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWRosterViewController.h"

@interface CSWRosterViewController ()

@end

@implementation CSWRosterViewController

@synthesize people,classId,thumbs;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    people = [NSArray array];
    thumbs =  [NSMutableArray array];
    
    [self setupUI];
    
    if (classId) {
        self.title = @"Roster";
        [self refresh];
    }
    
    
}

-(void) setupUI {
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh setTintColor:[UIColor lightCSWBlueColor]];
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
    return people.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"rosterCell";
    CSWRosterTableViewCell *cell = (CSWRosterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // forIndexPath:indexPath];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSWRosterTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    [cell setupWithData:(NSDictionary*)people[indexPath.row]];
    [cell setupImage:thumbs[indexPath.row]];
    
    NSLog(@"setup");

    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0f;
}

-(void) refresh {
    
    [self.refreshControl beginRefreshing];
    [self setRefreshControlTitle:@"Refreshing..."];
    
    CSWManager *manager = [CSWManager sharedManager];
    [manager getRosterForClassWithId:classId
                       andCompletion:^(NSArray *array) {
                           if (array.count > 0) {
                               if ([array[0] isMemberOfClass:[NSString class]]) {
                                   [self setTableHeaderMessage:array[0]];
                               }else{
                                   [self.refreshControl endRefreshing];
                                   [self setRefreshControlTitle:@"Pull to Refresh"];
                                   people = array;
                                   [self.tableView reloadData];
                                   
                                   UIImage *def = [UIImage imageNamed:@"defaultThumb.png"];
                                   
                                   for (int i = 0; i < people.count; i++) {
                                       NSDictionary *person = people[i];
                                       [thumbs addObject:def];
                                       if (![person[@"userThumb"] isMemberOfClass:[NSNull class]]) {
                                           [manager getThumbWithURL:person[@"userThumb"] andCompletion:^(UIImage *image) {
                                               if (image) {
                                                   
                                                   CGSize itemSize = CGSizeMake(167, 167);
                                                   UIGraphicsBeginImageContext(itemSize);
                                                   CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                                   [image drawInRect:imageRect];
                                                   image = UIGraphicsGetImageFromCurrentImageContext();
                                                   UIGraphicsEndImageContext();
                                                   
                                                   thumbs[i] = image;
                                                   [self.tableView reloadData];
                                               }
                                               
                                           }];
                                       }
                                       
                                   }
                               }
                           }
                           
                       }];
    
    
}

-(void) setRefreshControlTitle:(NSString*)s {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:s];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor lightCSWBlueColor] range:NSMakeRange(0, [s length])];
    self.refreshControl.attributedTitle = title;
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];
    [self.refreshControl setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    
}

//-(void) startActivityIndicator {
//    
//    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] init];
//    [ac setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [ac setColor:[UIColor darkCSWBlueColor]];
//    [ac setCenter:CGPointMake(self.tableView.frame.size.width / 2, 35)];
//    activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.tableHeaderView.frame.size.width, 70)];
//    [activityView addSubview:ac];
//    self.tableView.tableHeaderView = activityView;
//    [ac startAnimating];
//    
//}
//
//-(void) stopActivityIndicator{
//    [UIView animateWithDuration:0.1 animations:^{
//        [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 0, 0)];
//    } completion:^(BOOL finished) {
//        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
//    }];
//    activityView = nil;
//}

-(void) setTableHeaderMessage:(NSString*)message {
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    [label setText:message];
    [label setFont:[UIFont sanFranciscoFontWithSize:12]];
    [label setTextColor:[UIColor darkCSWBlueColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.tableView.tableHeaderView addSubview:label];
    
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
