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
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back  "
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"pushToRosterDetail" sender:self];
    
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
                                                   
//                                                   CGSize itemSize = CGSizeMake(167, 167);
//                                                   UIGraphicsBeginImageContext(itemSize);
//                                                   CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//                                                   [image drawInRect:imageRect];
//                                                   image = UIGraphicsGetImageFromCurrentImageContext();
//                                                   UIGraphicsEndImageContext();
                                                   
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


-(void) setTableHeaderMessage:(NSString*)message {
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    [label setText:message];
    [label setFont:[UIFont sanFranciscoFontWithSize:12]];
    [label setTextColor:[UIColor darkCSWBlueColor]];
    [label setBackgroundColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.tableView.tableHeaderView addSubview:label];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CSWDetailSearchViewController *controller = (CSWDetailSearchViewController*)[segue destinationViewController];
    long index = self.tableView.indexPathForSelectedRow.row;
    controller.data = people[index];
    controller.profilePic = thumbs[index];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathWithIndex:index] animated:true];
    
}



@end
