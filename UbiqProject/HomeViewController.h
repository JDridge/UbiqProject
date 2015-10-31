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
@property (weak, nonatomic) IBOutlet UITextField *CommonInterestPoints;
@property (weak, nonatomic) IBOutlet UISwitch *FirstLocationSwitch;
@property (strong, retain) CLLocationManager *currentLocationManager;

@property int direction;
@property int shakes;
@property Query *queryToPass;
@property BOOL locationFound;

- (IBAction) ConvergeLocations:(id)sender;
- (IBAction)SwitchTrigger:(id)sender;

- (CLPlacemark*) getCoordinateEquivalent:(NSString*) location;

- (BOOL) isValidLocationEntry:(NSString *) location;
- (BOOL) isTextFieldDefaultOrEmpty:(UITextField *)locationTextField;

- (void) setUpKeyboardToDismissOnReturn;
- (void) shake:(UIView*) shakeThisObject;
- (void) displayLocationCouldNotBeFoundAlert;
- (void) requestUsersCurrentLocation;
- (void) displayErrorForUnableToConverge;


@end

