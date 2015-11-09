//
//  ViewController.h
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Query.h"

@interface HomeViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *FirstLocation;
@property (weak, nonatomic) IBOutlet UITextField *SecondLocation;
@property (weak, nonatomic) IBOutlet UITextField *SearchCategory;
@property (weak, nonatomic) IBOutlet UISwitch *FirstLocationSwitch;
@property (strong, retain) CLLocationManager *currentLocationManager;

@property int direction;
@property int shakes;
@property Query *queryToPass;
@property BOOL locationFound;
@property BOOL isValidTextField;

- (IBAction) ConvergeLocations:(id)sender;
- (IBAction) SwitchTrigger:(id)sender;
- (IBAction)PopulateFields:(id)sender;

- (CLPlacemark*) getCoordinateEquivalent:(NSString*) location;

- (BOOL) isValidLocationEntry:(NSString*) location;
- (BOOL) isTextFieldDefaultOrEmpty:(UITextField*)locationTextField;
- (BOOL) textFieldShouldReturn:(UITextField*)textField;

- (void) disableFocusFromAllTextFields;
- (void) displayCurrentLocationDeniedByUser;
- (void) displayErrorForUnableToConverge;
- (void) displayLocationCouldNotBeFoundAlert;
- (void) locationManager:(CLLocationManager*)manager didFailWithError:(NSError *)error;
- (void) locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray *)locations;
- (void) requestUsersCurrentLocation;
- (void) setFirstLocationTextFieldDisabled;
- (void) setFirstLocationTextFieldEnabled;
- (void) setUpKeyboardToDismissOnReturn;
- (void) shake:(UIView*) shakeThisObject;
- (void) keyboardWillShow:(NSNotification *)notification;
- (void) keyboardWillHide:(NSNotification *)notification;
- (void) moveFrameToVerticalPosition:(float)position forDuration:(float)duration;
- (void) addGestureToDismissKeyboardOnTap;

@end

