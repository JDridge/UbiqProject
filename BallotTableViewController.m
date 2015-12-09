//
//  BallotTableViewController.m
//  UbiqProject
//
//  Created by Mario Laiseca-Ruiz on 12/7/15.
//  Copyright © 2015 Joey. All rights reserved.
//



#import "BallotTableViewController.h"
#import "SWRevealViewController.h"
#import "CustomTableCell.h"
#import "Ballot.h"
#import <Parse/Parse.h>
#import "BallotTableViewCell.h"
#import "Mailgun+Utilities.h"

@interface BallotTableViewController () {
    NSArray *firstQueryObjects;
    NSMutableArray *secondQueryObjects;
    NSMutableDictionary *pairedObjects;
    NSString *firstName;
    NSString *secondName;
    NSString *nameOfPlace;
}

@end

static NSString *myCellIdentifier = @"BallotCustomCell";

@implementation BallotTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Ballots";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStyleDone
                                   target:self.revealViewController
                                   action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    [self fetchParseData];

    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchParseData)
                  forControlEvents:UIControlEventValueChanged];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    
    UINib *nib = [UINib nibWithNibName:myCellIdentifier bundle:nil];
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

    //filtering data
    [[getFirstUserQuery whereKey:@"username" equalTo:[[PFUser currentUser] username]] whereKey:@"vote" equalTo:@"Not yet voted"];
    firstQueryObjects = [getFirstUserQuery findObjects];
    
    for (PFObject *object in firstQueryObjects)
        [ballotIDFromFirstQueryObjects addObject:object[@"ballotID"]];
    
    
    for (int i = 0; i < [ballotIDFromFirstQueryObjects count]; i++) {
        [getSecondUserQuery whereKey:@"ballotID" equalTo:ballotIDFromFirstQueryObjects[i]];
        
        //[getSecondUserQuery whereKey:@"vote" equalTo:@"Not yet voted"];
        [secondQueryObjects  addObject:[getSecondUserQuery findObjects]];
    }
    
    [self reloadData];
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
    
    BallotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier forIndexPath:indexPath];
    
    NSArray *currentObjects = secondQueryObjects[indexPath.row];
    
    PFObject *personThatIsNotYou;
    
    if(![currentObjects[0][@"username"]  isEqualToString:[[PFUser currentUser] username]]) {
        personThatIsNotYou = currentObjects[0];
    }
    else if(![currentObjects[1][@"username"] isEqualToString:[[PFUser currentUser] username]]) {
        personThatIsNotYou = currentObjects[1];
    }
    
    NSString *hi = [NSString stringWithFormat:@"%@ <%@> has invited to meet up at %@, located at %@. \nTap here to accept their invite!", personThatIsNotYou[@"name"], personThatIsNotYou[@"username"], personThatIsNotYou[@"nameOfPlace"], personThatIsNotYou[@"addressOfPlace"]];
    
    NSLog(@"%@", hi);
    cell.ballotLabel.text = hi;
    //Name
    //cell.firstPersonName.text = username1[@"username"];
    ///cell.secondPersonName.text = username2[@"username"];
    
    //Google Static Map
    NSString *staticMapURL = @"https://maps.googleapis.com/maps/api/staticmap?center=";
    NSString *coordinateString = personThatIsNotYou[@"coordinates"];
    //NSString *coordinateString2 = username2[@"friendsCoordinate"];
    //nameOfPlace = username1[@"nameOfPlace"];
    //NSArray *splitCoordinate = [NSArray arrayWithArray:[coordinateString componentsSeparatedByString:@","]];
    //NSArray *splitCoordinate2 = [NSArray arrayWithArray:[coordinateString2 componentsSeparatedByString:@","]];
//    float latitude = ([splitCoordinate[0] floatValue]+[splitCoordinate2[0] floatValue])/2;
//    float longitude = ([splitCoordinate[1] floatValue]+[splitCoordinate2[1] floatValue])/2;
//    NSString *stringLatitude = [NSString stringWithFormat:@"%1.6f", latitude];
//    NSString *stringLongitude = [NSString stringWithFormat:@"%1.6f", longitude];
//    NSString *midCoordinate = [NSString stringWithFormat:@"%@,%@", stringLatitude, stringLongitude];
    NSString *mapSpecifics = @"&zoom=15&size=300x300&markers=color:green%7Clabel:C%7C";
    NSString *theKey = @"&key=AIzaSyDuqaWuf7fMQ0gsFORLozfO4aDKHW38YWk";
    staticMapURL = [NSString stringWithFormat:@"%@%@%@%@%@", staticMapURL,coordinateString,mapSpecifics,coordinateString,theKey];
    NSURL *url = [NSURL URLWithString:staticMapURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    [cell.ballotImage setImage:image];
    
    //ballot
    //NSString *userVote1 = username1[@"vote"];
//    NSString *userVote2 = username2[@"vote"];
//
//    //firstName = username1[@"name"];
//    secondName = username2[@"name"];
//
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BallotTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Voting Time"
                                message:@"Would you like to meet up? \n Enter any comments you want to send to the other person below."
                                preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *alertRef = alert;

    UIAlertAction *voteYesButton = [UIAlertAction
                                 actionWithTitle:@"Yes"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
                                     [self emailTheOtherPersonWith:text status:@"Voted Yes" cell:cell];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    
    UIAlertAction *voteNoButton = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
                                     [self emailTheOtherPersonWith:text status:@"Voted No" cell:cell];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter comments here...";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];

    
    UIAlertAction *maybeLaterButton = [UIAlertAction
                                 actionWithTitle:@"Later"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:voteYesButton];
    [alert addAction:voteNoButton];
    [alert addAction:maybeLaterButton];
    
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void) emailTheOtherPersonWith:(NSString*)text status:(NSString*)voted cell:(BallotTableViewCell*)cell{
    NSLog(@"emailing...");
    //[Mailgun sendEmailToUserAboutStatusOfBallotWithComments:secondName email:cell.secondPersonName.text location:nameOfPlace status:voted comments:text];
    if([voted isEqualToString:@"Voted Yes"]) {
        NSLog(@"yes!!!");
    }
    else if([voted isEqualToString:@"Voted No"]) {
        NSLog(@"no :(");
    }
    else {
        NSLog(@"what...?");
    }
}



@end
