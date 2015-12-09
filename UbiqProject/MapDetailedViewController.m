
#import "MapDetailedViewController.h"
#import "YPAPISample.h"
#import <Parse/Parse.h>
#import "Mailgun+Utilities.h"
@interface MapDetailedViewController ()

@end

@implementation MapDetailedViewController

@synthesize nameLabel, pinLocation, myCustomAnnotation, friendsCustomAnnotation, myName, myPhone, myAddress, friendName, friendPhone, friendAddress, placeName, placePhone, placeAddress;

- (void)viewDidLoad {
    
    self.nameLabel.text = [pinLocation.annotation title];
    
    //[self putInBallotClass];

    myName.text = myCustomAnnotation.name;
    myPhone.text = myCustomAnnotation.email;
    myAddress.text = myCustomAnnotation.subtitle;
    friendName.text = friendsCustomAnnotation.name;
    friendPhone.text = friendsCustomAnnotation.email;
    friendAddress.text = friendsCustomAnnotation.subtitle;
    placeName.text = [pinLocation.annotation title];
    placePhone.text = @"phone";
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
    
    ballot[@"coordinates"] = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
    ballot[@"vote"] = @"Not yet voted";
    
    [ballot saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            NSLog(@"ballot saved");
        }
        else {
            NSLog(@"error: %@", [error description]);
        }
    }];

}
- (IBAction)yesTouched:(id)sender {
    NSLog(@"email isnt valid, but let's send it to robert's email address");
    [Mailgun sendEmailToUser:@"rvo@uh.edu"/*friendsCustomAnnotation.email*/];
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)nahManTouched:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}
@end