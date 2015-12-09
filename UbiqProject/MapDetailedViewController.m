
#import "MapDetailedViewController.h"
#import "YPAPISample.h"
#import <Parse/Parse.h>
#import "Mailgun+Utilities.h"
#import "SWRevealViewController.h"

@interface MapDetailedViewController ()

@end

@implementation MapDetailedViewController

@synthesize nameLabel, pinLocation, myCustomAnnotation, friendsCustomAnnotation, myName, myPhone, myAddress, friendName, friendPhone, friendAddress, placeName, placeAddress;

- (void)viewDidLoad {
    
    self.nameLabel.text = [pinLocation.annotation title];
    

    myName.text = myCustomAnnotation.name;
    myPhone.text = myCustomAnnotation.email;
    myAddress.text = myCustomAnnotation.subtitle;
    friendName.text = friendsCustomAnnotation.name;
    friendPhone.text = friendsCustomAnnotation.email;
    friendAddress.text = friendsCustomAnnotation.subtitle;
    placeName.text = [pinLocation.annotation title];
    placeAddress.text = [pinLocation.annotation subtitle];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) putInBallotClass {
    PFQuery *query = [PFQuery queryWithClassName:@"Ballot"];
    [query orderByDescending:@"createdAt"];
    
    PFObject *firstQuery = [query getFirstObject];
    
    NSString *mostRecentBallot = firstQuery[@"ballotID"];
    int ballotID = [[mostRecentBallot substringFromIndex:2] intValue] + 1;
    
    PFObject *ballot = [PFObject objectWithClassName:@"Ballot"];
    ballot[@"ballotID"] = [NSString stringWithFormat:@"BA%i", ballotID];
    
    ballot[@"username"] = [[PFUser currentUser] username];
    NSString *title = [pinLocation.annotation title];
    NSString *address = [pinLocation.annotation subtitle];
    CLLocationCoordinate2D coordinate = [pinLocation.annotation coordinate];
    ballot[@"nameOfPlace"] = title;
    ballot[@"addressOfPlace"] = address;
    ballot[@"coordinates"] = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    ballot[@"vote"] = @"Voted";
    ballot[@"myCoordinate"] = [NSString stringWithFormat:@"%f,%f", myCustomAnnotation.coordinate.latitude, myCustomAnnotation.coordinate.longitude];
    ballot[@"friendsCoordinate"] = [NSString stringWithFormat:@"%f,%f", friendsCustomAnnotation.coordinate.latitude, friendsCustomAnnotation.coordinate.longitude];
    ballot[@"name"] = myCustomAnnotation.name;
    [ballot saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"ballot saved");
        }
        else {
            NSLog(@"error: %@", [error description]);
        }
    }];
    
    PFObject *ballot2 = [PFObject objectWithClassName:@"Ballot"];
    ballot2[@"ballotID"] = [NSString stringWithFormat:@"BA%i", ballotID];
    ballot2[@"username"] = friendsCustomAnnotation.email;
    ballot2[@"nameOfPlace"] = title;
    ballot2[@"addressOfPlace"] = address;
    ballot2[@"coordinates"] = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    ballot2[@"vote"] = @"Not yet voted";
    ballot2[@"myCoordinate"] = [NSString stringWithFormat:@"%f,%f", myCustomAnnotation.coordinate.latitude, myCustomAnnotation.coordinate.longitude];
    ballot2[@"friendsCoordinate"] = [NSString stringWithFormat:@"%f,%f", friendsCustomAnnotation.coordinate.latitude, friendsCustomAnnotation.coordinate.longitude];
    ballot2[@"name"] = friendsCustomAnnotation.name;
    [ballot2 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"ballot saved");
        }
        else {
            NSLog(@"error: %@", [error description]);
        }
    }];

}
- (IBAction)yesTouched:(id)sender {
    [self putInBallotClass];
    NSLog(@"email isnt valid, but let's send it to robert's email address");
    [Mailgun sendEmailToUserRequestingBallot:friendsCustomAnnotation.name from:myCustomAnnotation.name email:friendsCustomAnnotation.email];
    [self displayEmailSent];
    //[[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)nahManTouched:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}


- (void)displayEmailSent {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Email Sent!"
                                message:[NSString stringWithFormat:@"Please wait for your friend, %@, to respond.", friendsCustomAnnotation.email]
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay 🙃"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self transitionToHomeViewController];
                                 }];
    [alert addAction:okayButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) transitionToHomeViewController {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ /* put code to execute here */
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        SWRevealViewController *detailViewController = (SWRevealViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"hamVC"];
        [self presentViewController:detailViewController animated:YES completion:nil];
        [[[self parentViewController] parentViewController] dismissViewControllerAnimated:YES completion:nil];
        
    });
}



@end