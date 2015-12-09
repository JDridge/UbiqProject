
#import "HomeViewController.h"
#import "Query.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SWRevealViewController.h"
#import <Parse/Parse.h>

@interface HomeViewController ()
@end

@implementation HomeViewController

@synthesize FriendsUsername, queryToPass, direction, shakes, SearchCategory, currentLocationManager, locationFound, isValidTextField, friendsUsernameToPass;

# pragma Method to populate the text fields with bars, houston, midtown houston.
- (IBAction)PopulateFields:(id)sender {
    SearchCategory.text = @"bars";
    FriendsUsername.text = @"jenny@talias.com";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Home";
    _barButton.target = self.revealViewController;
    _barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    queryToPass = [[Query alloc] init];
    [self setUpKeyboardToDismissOnReturn];
    [self addGestureToDismissKeyboardOnTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)ConvergeLocations:(id)sender {
    
    [self disableFocusFromAllTextFields];
    Query *setUpQueryToPass = [[Query alloc] init];
    isValidTextField = YES;
    [self validateTextField:FriendsUsername];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:FriendsUsername.text];
    PFObject *selectedUser = [[query findObjects] firstObject];
    
    if(selectedUser) {
        NSLog(@"user found.");
        setUpQueryToPass.category = SearchCategory.text;
        queryToPass = setUpQueryToPass;
        friendsUsernameToPass = selectedUser;
        [self performSegueWithIdentifier:@"mapVC" sender:nil];
    }
    else {
        [self displayFriendsUsernameCouldNotBeFound];
    }
    
    //if friends username is valid
    
    
    //friends username is not valid
        //display friends username could not be found
    
//    if(locationFound == NO && [FirstLocationSwitch isOn]) {
//        [self displayLocationCouldNotBeFoundAlert];
//    }
//    else if (isValidTextField) {
//        
//        NSMutableArray *locationsToPassRepresentedAsCoordinates  = [[NSMutableArray alloc] init];
//        setUpQueryToPass.locations = [[NSMutableArray alloc] init];
//        setUpQueryToPass.category = SearchCategory.text;
//        
//        //If the switch is turned on, the location is found, and the second location text field is a valid location.
//        if([FirstLocationSwitch isOn] && locationFound && [self isValidLocationEntry:SecondLocation.text]) {
//            [locationsToPassRepresentedAsCoordinates addObject:currentLocationManager.location];
//            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:SecondLocation.text]];
//            setUpQueryToPass.locations = locationsToPassRepresentedAsCoordinates;
//            queryToPass = setUpQueryToPass;
//            [self performSegueWithIdentifier:@"mapVC" sender:nil];
//            
//        }
//        //If the first and second location text fields are valid locations.
//        else if([self isValidLocationEntry:FirstLocation.text] && [self isValidLocationEntry:SecondLocation.text]) {
//            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:FirstLocation.text]];
//            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:SecondLocation.text]];
//            setUpQueryToPass.locations = locationsToPassRepresentedAsCoordinates;
//            queryToPass = setUpQueryToPass;
//            [self performSegueWithIdentifier:@"mapVC" sender:nil];
//        }
//        //Shouldn't reach here. But it is possible, I guess.
//        else {
//            [self displayErrorForUnableToConverge];
//        }
//    }
//    else {
//        [self displayErrorForUnableToConverge];
//    }
}

- (void)displayFriendsUsernameCouldNotBeFound {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Error!"
                                message:@"We could not find your friends username! Please try again."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay 🙃"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:okayButton];
    [self presentViewController:alert animated:YES completion:nil];
}

//Checks if the TextField passed in is valid or not.
- (void) validateTextField:(UITextField*)textField {
    if([self isTextFieldDefaultOrEmpty:textField]) {
        direction = 1;
        shakes = 1;
        [self shake:textField];
        isValidTextField = NO;
    }
}


//checks if the text boxes are equal to a set of defined strings.
- (BOOL) isTextFieldDefaultOrEmpty:(UITextField *)locationTextField {
    NSString *emptyString = @"";
    NSString *firstTextFieldDefault = @"Enter your friend's username!";
    NSString *secondTextFieldDefault = @"Enter another location!";
    NSString *warningMessage = @"Please enter in another username!";
    
    if([locationTextField.text isEqualToString:emptyString] ||
       [locationTextField.text isEqualToString:firstTextFieldDefault] ||
       [locationTextField.text isEqualToString:secondTextFieldDefault] ||
       [locationTextField.text isEqualToString:warningMessage]) {
        locationTextField.text = warningMessage;
        return true;
    }
    else {
        return false;
    }
}

//Needed to make the keyboard dismiss when the return key is pressed.
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//Removes the focus off of all of the text fields.
- (void) disableFocusFromAllTextFields {
    [FriendsUsername resignFirstResponder];
    [SearchCategory resignFirstResponder];
}


//Displays an alert if the application is unable to converge.
- (void) displayErrorForUnableToConverge {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Error!"
                                message:@"For some reason we cannot converge your locations. Try again in a bit!"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay 🙃"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:okayButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) setUpKeyboardToDismissOnReturn {
    [FriendsUsername setDelegate:self];
    [SearchCategory setDelegate:self];
}

- (void) shake:(UIView *)shakeThisObject {
    [UIView animateWithDuration:0.03 animations:^{
        shakeThisObject.transform = CGAffineTransformMakeTranslation(5 * direction, 0);
    }
                     completion:^(BOOL finished) {
                         if(shakes >= 10) {
                             shakeThisObject.transform = CGAffineTransformIdentity;
                             return;
                         }
                         shakes++;
                         direction = direction * -1;
                         [self shake:shakeThisObject];
                     }
     ];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *viewController = [segue destinationViewController];
    viewController.queryToShow = queryToPass;
    //viewController.numberOfLocations = [queryToPass.locations count];
    viewController.friendsUserInfo = friendsUsernameToPass;
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float newVerticalPosition = -keyboardSize.height;
    [self moveFrameToVerticalPosition:newVerticalPosition forDuration:0.3f];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveFrameToVerticalPosition:0.0f forDuration:0.3f];
}

- (void)moveFrameToVerticalPosition:(float)position forDuration:(float)duration {
    CGRect frame = self.view.frame;
    frame.origin.y = position;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = frame;
    }];
}

//Dismisses keyboard on tap anywhere outside the keyboard.
- (void)addGestureToDismissKeyboardOnTap {
    UITapGestureRecognizer *tapOutsideOfKeyboard = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(disableFocusFromAllTextFields)];
    [self.view addGestureRecognizer:tapOutsideOfKeyboard];
}

@end
