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
//<CLLocationManagerDelegate>
@end

@implementation HomeViewController

@synthesize FirstLocation, SecondLocation, queryToPass, direction, shakes, HomeSearchBar, FirstLocationSwitch;

- (void)viewDidLoad {
    NSLog(@"hi");
    [super viewDidLoad];
    queryToPass = [[Query alloc] init];
    [self setUpKeyboardToDismissOnReturn];
    
    
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (CLPlacemark*) getCoordinateEquivalent:(NSString*) location {
    __block BOOL placeMarkUpdated = NO;
    __block CLPlacemark *placemark = nil;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:location completionHandler:^(NSArray* placemarks, NSError* error) {
            placemark = [placemarks objectAtIndex:0];
    }];
    
    while(!placemark) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    //while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !placeMarkUpdated){};
    return placemark;
}

- (BOOL) isValidLocationEntry:(NSString *) location{
    BOOL isValid = NO;
    
    if([self getCoordinateEquivalent:location] != nil) {
        isValid = YES;
    }
    return isValid;
}

- (IBAction)ConvergeLocations:(id)sender {
    
    Query *setUpQueryToPass = [[Query alloc] init];
    NSMutableArray *locationsToPass;
    BOOL isInvalidEntry = NO;
    [locationsToPass addObject:FirstLocation.text];
    [locationsToPass addObject:SecondLocation.text];
    direction = 1;
    shakes = 1;
    if([FirstLocation.text isEqual: @""] || [FirstLocation.text isEqualToString:@"Enter location..."]) {
        FirstLocation.text = @"SHAKE SHAKE";
        [self shake:FirstLocation];
        isInvalidEntry = YES;
    }
    if([SecondLocation.text isEqual:@""] || [SecondLocation.text isEqualToString:@"Enter location..."]) {
        SecondLocation.text = @"SHAKE SHAKE SHAKEEE";
        [self shake:SecondLocation];
        isInvalidEntry = YES;
    }
    
    //add validation for valid addresses
    if (!isInvalidEntry) {
        if([self isValidLocationEntry:FirstLocation.text] && [self isValidLocationEntry: SecondLocation.text]) {
            NSMutableArray *locationsToPassRepresentedAsCoordinates  = [[NSMutableArray alloc] init];
            
            setUpQueryToPass.locations = [[NSMutableArray alloc] init];
            
            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:FirstLocation.text]];
            [locationsToPassRepresentedAsCoordinates addObject:[self getCoordinateEquivalent:SecondLocation.text]];
            
            setUpQueryToPass.locations = locationsToPassRepresentedAsCoordinates;
            
            queryToPass = setUpQueryToPass;
            
            [self performSegueWithIdentifier:@"mapVC" sender:nil];
        }
    }

}

- (NSMutableArray*) getCoordinateLocations {
    NSMutableArray *listOfCoordinateValues = [[NSMutableArray alloc] init];
    // CLLocation *location = [[CLLocation alloc] initWithLatitude:29.7604 longitude:95.3698];
    //[listOfCoordinateValues addObject:location];
    
    //new code
    
  
    
    
    
    //end of code
    
    
    return listOfCoordinateValues;
    
}





- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *viewController = [segue destinationViewController];
    
    viewController.FirstLocationSwitchOnOrOff = [FirstLocationSwitch isOn];

    
    
    viewController.queryToShow = queryToPass;
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
    [HomeSearchBar setDelegate:self];
}

@end
