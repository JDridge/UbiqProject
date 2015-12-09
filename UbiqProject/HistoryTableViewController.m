//
//  HistoryTableViewController.m
//  UbiqProject
//
//  Created by chris ly on 12/8/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "SWRevealViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryTableViewController.h"

@interface HistoryTableViewController () {
    NSArray *firstQueryObjects;
    NSMutableArray *secondQueryObjects;
    NSMutableDictionary *pairedObjects;
}

@end

@implementation HistoryTableViewController

//myCoordinate & friendsCoordinate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"History";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Menu"
                                   style:UIBarButtonItemStyleDone
                                   target:self.revealViewController
                                   action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //[self fetchParseData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchParseData)
                  forControlEvents:UIControlEventValueChanged];
    
    
    //
    
    //
    //
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    static NSString *myCellIdentifier = @"HistoryCustomCell";
    UINib *nib = [UINib nibWithNibName:@"HistoryCustomCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:myCellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchParseData{
    PFQuery *getFirstUserQuery = [PFQuery queryWithClassName:@"Ballot"];
    PFQuery *getSecondUserQuery = [PFQuery queryWithClassName:@"Ballot"];
    
    NSMutableArray *ballotIDFromFirstQueryObjects = [[NSMutableArray alloc] init];
    secondQueryObjects = [[NSMutableArray alloc] init];
    
    NSMutableArray *pairedArray = [[NSMutableArray alloc] init];
    pairedObjects = [[NSMutableDictionary alloc] init];
    //filtering data
    [getFirstUserQuery whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    firstQueryObjects = [getFirstUserQuery findObjects];
    
    for (PFObject *object in firstQueryObjects)
        [ballotIDFromFirstQueryObjects addObject:object[@"ballotID"]];
    

    for (int i = 0; i < [ballotIDFromFirstQueryObjects count]; i++) {
        [getSecondUserQuery whereKey:@"ballotID" equalTo:ballotIDFromFirstQueryObjects[i]];
        [secondQueryObjects  addObject:[getSecondUserQuery findObjects]];
    }

//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            NSLog(@"%@", objects);
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
    
    [self reloadData];
    NSLog(@"****This is where the URL should be updating****");
    
}


- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        //CODE HERE
        
        [self.refreshControl endRefreshing];
    }
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;
    
    
    
    // Return the number of sections.
    if ([secondQueryObjects count] > 0) {
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        //messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [secondQueryObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCellIdentifier = @"HistoryCustomCell";
    
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier forIndexPath:indexPath];
    
    //SCALABILITY SUCKS HERE ONLY GOOD FOR TWO PEOPLE CHANGE LATER ON FOR FUTURE IMPLEMENTATIONS
    NSArray *currentObjects = secondQueryObjects[indexPath.row];
    PFObject *username1 = currentObjects[1];
    PFObject *username2 = currentObjects[0];
    
    //Name
    cell.firstPersonName.text = username1[@"username"];
    cell.secondPersonName.text = username2[@"username"];
    
    //Google Static Map
    NSString *staticMapURL = @"https://maps.googleapis.com/maps/api/staticmap?center=";
    NSString *coordinateString = username1[@"myCoordinate"];
    NSString *coordinateString2 = username2[@"friendsCoordinate"];
    NSArray *splitCoordinate = [NSArray arrayWithArray:[coordinateString componentsSeparatedByString:@","]];
    NSArray *splitCoordinate2 = [NSArray arrayWithArray:[coordinateString2 componentsSeparatedByString:@","]];
    float latitude = ([splitCoordinate[0] floatValue]+[splitCoordinate2[0] floatValue])/2;
    float longitude = ([splitCoordinate[1] floatValue]+[splitCoordinate2[1] floatValue])/2;
    NSString *stringLatitude = [NSString stringWithFormat:@"%1.6f", latitude];
    NSString *stringLongitude = [NSString stringWithFormat:@"%1.6f", longitude];
    NSString *midCoordinate = [NSString stringWithFormat:@"%@,%@", stringLatitude, stringLongitude];
    NSString *mapSpecifics = @"&zoom=15&size=300x300&markers=color:green%7Clabel:C%7C";
    NSString *theKey = @"&key=AIzaSyDuqaWuf7fMQ0gsFORLozfO4aDKHW38YWk";
    staticMapURL = [NSString stringWithFormat:@"%@%@%@%@%@", staticMapURL,midCoordinate,mapSpecifics,midCoordinate,theKey];
    
    NSURL *url = [NSURL URLWithString:staticMapURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    [cell.mapImage setImage:image];
    
    //ballot
    NSString *userVote1 = username1[@"vote"];
    NSString *userVote2 = username2[@"vote"];
    
    if([userVote1 isEqualToString: @"Yes"]){
        userVote1 = [NSString stringWithFormat: @"%@ has voted Yes", username1[@"name"]];
    }else if([userVote1 isEqualToString: @"No"]){
        userVote1 = [NSString stringWithFormat: @"%@ has voted No", username1[@"name"]];
    }else{
        userVote1 = [NSString stringWithFormat: @"%@ has not yet voted", username1[@"name"]];
    }
    cell.firstPersonVote.text = userVote1;
    
    if([userVote2 isEqualToString: @"Yes"]){
        userVote2 = [NSString stringWithFormat: @"%@ has voted Yes", username2[@"name"]];
    }else if([userVote2 isEqualToString: @"No"]){
        userVote2 = [NSString stringWithFormat: @"%@ has voted No", username2[@"name"]];
    }else{
        userVote2 = [NSString stringWithFormat: @"%@ has not yet voted", username2[@"name"]];
    }
    cell.secondPersonVote.text = userVote2;
    
    return cell; //
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
