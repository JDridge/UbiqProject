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

@synthesize CategorySegmentedControl, FirstLocation, SecondLocation, queryToPass, direction, shakes;

- (void)viewDidLoad {
    NSLog(@"hi");
    [super viewDidLoad];
    queryToPass = [[Query alloc] init];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated {
    
}

- (BOOL) isValidLocationEntry:(NSString *) location{
    
    __block BOOL isValid = NO;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:location completionHandler:^(NSArray* placemarks, NSError* error) {
            if(error != nil) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            else {
                [placemarks objectAtIndex:0];
                isValid = YES;
            }
        }];
    /*
     if([FirstLocation.text isEqual: @""] || [FirstLocation.text isEqualToString:@"Enter location..."]) {
     return false;
         
     }
     if([SecondLocation.text isEqual:@""] || [SecondLocation.text isEqualToString:@"Enter location..."]) {
     return false;
     }
    */
    return isValid;
}

- (IBAction)ConvergeLocations:(id)sender {
    
    Query *setUpQueryToPass = [[Query alloc] init];
    NSMutableArray *locationsToPass;
    
    [locationsToPass addObject:FirstLocation.text];
    [locationsToPass addObject:SecondLocation.text];
    /*
    if([FirstLocation.text isEqual: @""] || [FirstLocation.text isEqualToString:@"Enter location..."]) {
        FirstLocation.text = @"you screwed up";
    }
    if([SecondLocation.text isEqual:@""] || [SecondLocation.text isEqualToString:@"Enter location..."]) {
        SecondLocation.text = @"you also screwed up";
    }
    */
    if([self isValidLocationEntry:FirstLocation.text]) { //add validation for valid addresses
        setUpQueryToPass.category = [CategorySegmentedControl titleForSegmentAtIndex:CategorySegmentedControl.selectedSegmentIndex];
        NSMutableArray *locationsToPassRepresentedAsCoordinates  = [[NSMutableArray alloc] init];

        setUpQueryToPass.locations = [[NSMutableArray alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:29.7604 longitude:95.3698];
        [locationsToPassRepresentedAsCoordinates  addObject:location];

        setUpQueryToPass.locations = locationsToPassRepresentedAsCoordinates;
        
        queryToPass = setUpQueryToPass;
        
        [self performSegueWithIdentifier:@"mapVC" sender:nil];
    }
    else {
        direction = 1;
        shakes = 0;
        [self shake:FirstLocation];
        [self shake:SecondLocation];
    }
}

- (NSMutableArray*) getCoordinateLocations {
    NSMutableArray *listOfCoordinateValues = [[NSMutableArray alloc] init];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:29.7604 longitude:95.3698];

    [listOfCoordinateValues addObject:location];

    return listOfCoordinateValues;
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapViewController *viewController = [segue destinationViewController];
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
@end
