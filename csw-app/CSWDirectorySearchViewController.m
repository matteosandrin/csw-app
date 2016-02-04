//
//  CSWDirectorySearchViewController.m
//  csw-app
//
//  Created by Matteo Sandrin on 22/11/15.
//  Copyright © 2015 Matteo Sandrin. All rights reserved.
//

#import "CSWDirectorySearchViewController.h"

@interface CSWDirectorySearchViewController ()

@end

@implementation CSWDirectorySearchViewController

@synthesize people,thumbs;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    shouldClear = true;
    people = [NSArray array];
    thumbs =  [NSMutableArray array];
    [self setupUI];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    grade = 0;
    directory = 851;
    [self processErrorWithString:@"Search the school directory"];
//    [self refresh];
    
    
}

-(void) setupUI {
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh setTintColor:[UIColor lightCSWBlueColor]];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self setRefreshControlTitle:@"Pull to Refresh"];
    [self.refreshControl setTintColor:[UIColor lightCSWBlueColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont sanFranciscoFontWithSize:17]
                                                                      }];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    [self.searchBar setBarTintColor:[UIColor darkCSWBlueColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor darkCSWBlueColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setBackgroundColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor darkCSWBlueColor]];
    self.searchBar.delegate = self;
    [self.searchBar setShowsSearchResultsButton:true];
    self.navigationItem.titleView = self.searchBar;
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor darkCSWBlueColor]];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
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
    
    static NSString *CellIdentifier = @"searchCell";
    CSWSearchTableViewCell *cell = (CSWSearchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSWSearchTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailSegue:)];
    [cell addGestureRecognizer:tapped];
    cell.id_num = indexPath.row;
    [cell setupWithData:(NSDictionary*)people[indexPath.row]];
    [cell setupImage:thumbs[indexPath.row]];
    
    NSLog(@"setup");
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105.0f;
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

-(void) detailSegue:(id)sender {
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    selectedCellId = [(CSWSearchTableViewCell*)gesture.view id_num];
    shouldClear = false;
    [self performSegueWithIdentifier:@"pushToSearchDetail" sender:self];
    
}

-(void) refresh {
    
    [self.refreshControl beginRefreshing];
    [self setRefreshControlTitle:@"Searching..."];
    
    CSWManager *manager = [CSWManager sharedManager];
    [manager getPeopleWithQuery:self.searchBar.text
                       andGrade:grade
                   andDirectory:directory
                  andCompletion:^(NSArray *array) {
                           if (array.count > 0) {
                               if ([array[0] isKindOfClass:[NSString class]]) {
//                                   [self setTableHeaderMessage:array[0]];
                               }else{
                                   [self.refreshControl endRefreshing];
                                   [self setRefreshControlTitle:@"Pull to Refresh"];
                                   
                                   if (array.count > 50) {
                                       array = [array subarrayWithRange:NSMakeRange(0, 50)];
                                   }
                                   
                                   people = array;
                                   [self.tableView reloadData];
                                   
                                   UIImage *def = [UIImage imageNamed:@"defaultThumb.png"];
                                   thumbs =  [NSMutableArray array];
                                   
                                   for (int i = 0; i < people.count; i++) {
                                       NSDictionary *person = people[i];
                                       [thumbs addObject:def];
                                       if (![person[@"LargeFileName"] isMemberOfClass:[NSNull class]]) {
                                           [manager getThumbWithURL:person[@"LargeFileName"] andCompletion:^(UIImage *image) {
                                               if (image) {
                                                   
//                                                   CGSize itemSize = CGSizeMake(320, 167);
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
                           }else{
                               [self processErrorWithString:@"The search returned no results"];
                               [self.refreshControl endRefreshing];
                               [self setRefreshControlTitle:@"Pull to Refresh"];
                               people = [NSArray array];
                               [self.tableView reloadData];
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

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self performSearch];
    [self.searchBar resignFirstResponder];
    
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [searchTimer invalidate];
    
    if (searchText.length > 2) {
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(performSearch) userInfo:nil repeats:false];
    }else if (searchText.length == 0){
        [self clearResults];
    }
    
}

-(void) performSearch {
    [[[[CSWManager sharedManager] manager] operationQueue] cancelAllOperations];
    [self refresh];
    [loadingView removeFromSuperview];
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
}

-(void) searchBarResultsListButtonClicked:(UISearchBar *)searchBar {

   [self performSegueWithIdentifier:@"searchParams" sender:self];
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"began");
    [self.searchBar resignFirstResponder];
    
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"began");
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"searchParams"]) {
        CSWSearchPopoverViewController *dvc = (CSWSearchPopoverViewController*) segue.destinationViewController;
        [dvc setGrade:grade];
        [dvc setDirectory:directory];
        UIPopoverPresentationController *controller = dvc.popoverPresentationController;
        if (controller) {
            popoverController = dvc;
            controller.delegate = self;
            controller.sourceView = self.searchBar;
            controller.sourceRect = self.searchBar.frame;
        }
    }else if ([[segue identifier] isEqualToString:@"pushToSearchDetail"]) {
        [self.searchBar resignFirstResponder];
        CSWDetailSearchViewController *controller = (CSWDetailSearchViewController*)[segue destinationViewController];
        long index = selectedCellId;
        controller.data = people[index];
        controller.profilePic = thumbs[index];
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathWithIndex:index] animated:true];
    }
    
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

-(void) popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    grade = [popoverController getGrade];
    directory = [popoverController getDirectory];
    [self refresh];
    
}

-(void) processErrorWithString:(NSString*)error {
    
    loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    [loadingView setBackgroundColor:[UIColor whiteColor]];
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.text = error;
    errorLabel.font = [UIFont sanFranciscoFontWithSize:15];
    errorLabel.numberOfLines = 2;
    [errorLabel setTextAlignment:NSTextAlignmentCenter];
    [errorLabel setMinimumScaleFactor:0.5];
    [errorLabel setTextColor:[UIColor darkCSWBlueColor]];
    
    CGSize winSize = self.view.frame.size;
    float labelWidth = winSize.width * 0.9f;
    [errorLabel setFrame:CGRectMake((winSize.width-labelWidth)/2, (winSize.height)/2-90, labelWidth, 75)];
    [loadingView addSubview:errorLabel];
    [self.tableView addSubview:loadingView];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:true];
    [self clearResults];
}

-(void) clearResults{
    if (shouldClear) {
        people = [NSArray array];
        thumbs = [NSMutableArray array];
        [self.tableView reloadData];
        [self.searchBar setText:@""];
    }
    shouldClear = true;
    NSLog(@"clear");
    
}


@end
