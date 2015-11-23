
#import "HomeViewController.h"
#import "Query.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface HomeViewController () 
@end

@implementation HomeViewController

@synthesize FirstLocation, SecondLocation, queryToPass, direction, shakes, FirstLocationSwitch, SearchCategory, currentLocationManager, locationFound, isValidTextField, textField, xCoordinatePlacement, yCoordinatePlacement, textFieldTagNumber, textFieldArray;

# pragma Method to populate the text fields with bars, houston, midtown houston.
- (IBAction)PopulateFields:(id)sender {
    SearchCategory.text = @"bars";
    FirstLocation.text = @"Houston, TX";
    SecondLocation.text = @"Midtown Houston, TX";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queryToPass = [[Query alloc] init];
    textFieldArray = [[NSMutableArray alloc] init];
    [self setUpKeyboardToDismissOnReturn];
    [self addGestureToDismissKeyboardOnTap];
    
    xCoordinatePlacement = 200;
    yCoordinatePlacement = 200;
    textFieldTagNumber = 0;
    
    NSString *pathToApiKeys = [[NSBundle mainBundle] pathForResource: @"APIKeys" ofType: @"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToApiKeys]) {
        NSLog(@"APIKeys.plist is found.");
        NSDictionary *allKeys = [NSDictionary dictionaryWithContentsOfFile:pathToApiKeys];
        NSString *yelpApiKey = [allKeys objectForKey:@"Yelp API Key"];
        NSString *parseApiKey = [allKeys objectForKey:@"Parse API Key"];
    }
    else {
        NSLog(@"APIKeys.plist missing!");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# warning Find a way to prevent the user from spamming the "Converge" button.
- (IBAction)ConvergeLocations:(id)sender {
    
    [self disableFocusFromAllTextFields];
    Query *setUpQueryToPass = [[Query alloc] init];
    isValidTextField = YES;
    [self validateTextField:FirstLocation];
    [self validateTextField:SecondLocation];
    
    if(locationFound == NO && [FirstLocationSwitch isOn]) {
        [self displayLocationCouldNotBeFoundAlert];
    }
    else if (isValidTextField) {
        
        NSMutableArray *locationsToPassRepresentedAsCoordinates  = [[NSMutableArray alloc] init];
        setUpQueryToPass.locations = [[NSMutableArray alloc] init];
        setUpQueryToPass.category = SearchCategory.text;
        
        //If the switch is turned on, the location is found, and the second location text field is a valid location.
        if([FirstLocationSwitch isOn] && locationFound && [self isValidLocationEntry:SecondLocation.text]) {
            [locationsToPassRepresentedAsCoordinates addObject:currentLocationManager.location];
            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:SecondLocation.text]];
            setUpQueryToPass.locations = locationsToPassRepresentedAsCoordinates;
            queryToPass = setUpQueryToPass;
            [self performSegueWithIdentifier:@"mapVC" sender:nil];
            
        }
        //If the first and second location text fields are valid locations.
        else if([self isValidLocationEntry:FirstLocation.text] && [self isValidLocationEntry:SecondLocation.text]) {
            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:FirstLocation.text]];
            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:SecondLocation.text]];
            setUpQueryToPass.locations = locationsToPassRepresentedAsCoordinates;
            queryToPass = setUpQueryToPass;
            [self performSegueWithIdentifier:@"mapVC" sender:nil];
        }
        //Shouldn't reach here. But it is possible, I guess.
        else {
            [self displayErrorForUnableToConverge];
        }
    }
    else {
        [self displayErrorForUnableToConverge];
    }
}

- (IBAction)addButton:(id)sender {
    yCoordinatePlacement += 60;
    textField = [[UITextField alloc]initWithFrame:CGRectMake(xCoordinatePlacement, yCoordinatePlacement, 148, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.tag = textFieldTagNumber;
    textField.delegate = self;
    textField.text = @"Enter Location";
    [textFieldArray addObject:textField];
    [self.view addSubview:textField];
    NSLog(@"add object count: %i", textFieldArray.count);
    textFieldTagNumber ++;
}

- (IBAction)removeButton:(id)sender {
    if (textFieldTagNumber >= 0){
        UITextField *textFieldToRemove = [textFieldArray objectAtIndex:(textFieldTagNumber-1)];
            NSLog(@"baaaaaaam! remove %i", textFieldArray.count);
            [textFieldArray removeObject:textFieldToRemove];
            [textFieldToRemove removeFromSuperview];
        textFieldTagNumber --;
    }

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

- (IBAction) SwitchTrigger:(id)sender {
    if (FirstLocationSwitch.on) {
        [self setFirstLocationTextFieldDisabled];
        [self requestUsersCurrentLocation];
    }
    else { //FirstLocationSwitch is turned off.
        [self setFirstLocationTextFieldEnabled];
    }
}


# warning Find a way to terminate the process if it is taking too long.
- (CLPlacemark*) getCoordinateEquivalent:(NSString*) location {
    __block CLPlacemark *placemark = nil;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:location completionHandler:^(NSArray* placemarks, NSError* error) {
        placemark = [placemarks objectAtIndex:0];
    }];
    
    while(!placemark) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return placemark;
}

//Validates whether the location entered is valid or not.
- (BOOL) isValidLocationEntry:(NSString*) location {
    BOOL isValid = NO;
    
    if([self getCoordinateEquivalent:location] != nil) {
        isValid = YES;
    }
    
    return isValid;
}

//checks if the text boxes are equal to a set of defined strings.
- (BOOL) isTextFieldDefaultOrEmpty:(UITextField *)locationTextField {
    NSString *emptyString = @"";
    NSString *firstTextFieldDefault = @"Enter location!";
    NSString *secondTextFieldDefault = @"Enter another location!";
    NSString *warningMessage = @"Please enter an appropriate location!";
    
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
    [FirstLocation resignFirstResponder];
    [SecondLocation resignFirstResponder];
    [SearchCategory resignFirstResponder];
}

//Displays an alert if the user denies their location services.
- (void) displayCurrentLocationDeniedByUser {

    [self.FirstLocationSwitch setOn:NO animated:YES];
    [self setFirstLocationTextFieldEnabled];
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Location Services Denied!"
                                message:@"To re-enable, please go to Settings and turn on Location Service for the Converge app."
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Take me to the settings!"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                 }];
    
    UIAlertAction *dismissButton = [UIAlertAction
                                 actionWithTitle:@"Dismiss"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:okayButton];
    [alert addAction:dismissButton];
    [self presentViewController:alert animated:YES completion:nil];
    
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

//If the GPS is too slow to get the current location and they tried to converge, this will be called to let them know to wait.
- (void) displayLocationCouldNotBeFoundAlert {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"No Location!"
                                message:@"Hey there! We couldn't find your location. Try again in a bit!"
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

//Delegate method that is called if the user denies permission for the app to access their location services.
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            [self displayCurrentLocationDeniedByUser];
        }
    }
}

//delegate method that runs when the current has been updated.
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    locationFound = YES; //user's location has been obtained.
}

//gets the user's current location.
- (void)requestUsersCurrentLocation {
    locationFound = NO; //this flag is to let us know if the user's location has been obtained
    currentLocationManager = [[CLLocationManager alloc] init];
    currentLocationManager.delegate = self;
    [currentLocationManager requestWhenInUseAuthorization];
    currentLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    currentLocationManager.distanceFilter = kCLDistanceFilterNone;
    [self.currentLocationManager startUpdatingLocation];
}

- (void) setFirstLocationTextFieldDisabled {
    [FirstLocation setEnabled: NO];
    FirstLocation.text = @"Current Location";
    FirstLocation.backgroundColor =  [UIColor orangeColor];
    FirstLocation.textColor = [UIColor whiteColor];
}

- (void) setFirstLocationTextFieldEnabled {
    [FirstLocation setEnabled: YES];
    FirstLocation.text = @"";
    FirstLocation.backgroundColor =  [UIColor whiteColor];
    FirstLocation.textColor = [UIColor colorWithRed: 2.0f/255.0f green: 132.0f/255.0f blue: 130.0f/255.0f alpha:1.0f];
}

- (void) setUpKeyboardToDismissOnReturn {
    [FirstLocation setDelegate:self];
    [SecondLocation setDelegate:self];
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
    viewController.numberOfLocations = [queryToPass.locations count];
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
