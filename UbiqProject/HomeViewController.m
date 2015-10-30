//
//  ViewController.m
//  UbiqProject
//
//  Created by Joey on 10/2/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "HomeViewController.h"
#import "Query.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface HomeViewController ()
@end

@implementation HomeViewController

@synthesize FirstLocation, SecondLocation, queryToPass, direction, shakes, FirstLocationSwitch, CommonInterestPoints, currentLocationManager, locationFound;

- (void)viewDidLoad {
    [super viewDidLoad];
    queryToPass = [[Query alloc] init];
    [self setUpKeyboardToDismissOnReturn];
}

- (IBAction)SwitchTrigger:(id)sender {
    if (FirstLocationSwitch.on) {
        [FirstLocation setEnabled: NO];
        FirstLocation.text = @"Current Location";
        FirstLocation.backgroundColor =  [UIColor orangeColor];
        FirstLocation.textColor = [UIColor whiteColor];
        
        locationFound = NO;
        currentLocationManager = [[CLLocationManager alloc] init];
        currentLocationManager.delegate = self;
        [currentLocationManager requestWhenInUseAuthorization];
        currentLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        currentLocationManager.distanceFilter = kCLDistanceFilterNone;
        [self.currentLocationManager startUpdatingLocation];

    }
    else {
        [FirstLocation setEnabled: YES];
        FirstLocation.text = @"";
        FirstLocation.backgroundColor =  [UIColor whiteColor];
        FirstLocation.textColor = [UIColor colorWithRed: 2.0f/255.0f green: 132.0f/255.0f blue: 130.0f/255.0f alpha:1.0f];
    }
}

//delegate method that runs when the current has been updated.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    locationFound = YES;
    CLLocation* loc = [locations lastObject]; // locations is guaranteed to have at least one object
    float latitude = loc.coordinate.latitude;
    float longitude = loc.coordinate.longitude;
    NSLog(@"%.8f",latitude);
    NSLog(@"%.8f",longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

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

- (BOOL) isValidLocationEntry:(NSString *) location {
    BOOL isValid = NO;
    
    if([self getCoordinateEquivalent:location] != nil) {
        isValid = YES;
    }
    
    return isValid;
}

- (IBAction)ConvergeLocations:(id)sender {
    
    Query *setUpQueryToPass = [[Query alloc] init];
    BOOL isValidTextField = YES;
    
    if([self isTextFieldDefaultOrEmpty:FirstLocation]) {
        direction = 1;
        shakes = 1;
        [self shake:FirstLocation];
        isValidTextField = NO;
    }
    if([self isTextFieldDefaultOrEmpty:SecondLocation]) {
        direction = 1;
        shakes = 1;
        [self shake:SecondLocation];
        isValidTextField = NO;
    }
    
    if (locationFound && isValidTextField) {
        if(([FirstLocationSwitch isOn] || [self isValidLocationEntry: FirstLocation.text]) && [self isValidLocationEntry: SecondLocation.text]) {
            
            NSMutableArray *locationsToPassRepresentedAsCoordinates  = [[NSMutableArray alloc] init];
            
            setUpQueryToPass.locations = [[NSMutableArray alloc] init];
            if (FirstLocationSwitch.on) {
                [locationsToPassRepresentedAsCoordinates addObject:currentLocationManager.location];
            }
            else {
                [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:FirstLocation.text]];
            }
            
            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:SecondLocation.text]];
            
            setUpQueryToPass.locations = locationsToPassRepresentedAsCoordinates;
            
            queryToPass = setUpQueryToPass;
            
            [self performSegueWithIdentifier:@"mapVC" sender:nil];
        }
    }
    else if(locationFound == NO) {
        //display popup as to why location wasn't found
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *viewController = [segue destinationViewController];
    viewController.FirstLocationSwitchOnOrOff = [FirstLocationSwitch isOn];
    viewController.queryToShow = queryToPass;
    viewController.commonPoints = CommonInterestPoints.text;
}

-(void)shake:(UIView *)shakeThisObject {
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
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) setUpKeyboardToDismissOnReturn {
    [FirstLocation setDelegate:self];
    [SecondLocation setDelegate:self];
}

-(BOOL) isTextFieldDefaultOrEmpty:(UITextField *)locationTextField {
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


@end
