//
//  MapViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 10/18/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "MapViewController.h"
#import "Query.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize ConvergeMapView, queryToShow, locationManager, addressCoordinates;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"💩");
    
    [self loadConvergeMapView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadConvergeMapView {
    self.ConvergeMapView.delegate = self;

    self.locationManager= [[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    [self.locationManager requestAlwaysAuthorization];
    addressCoordinates = self.locationManager.location.coordinate;
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .1f; //the zoom level in degrees
    zoom.longitudeDelta = .1f;//the zoom level in degrees
    MKCoordinateRegion myRegion;
    myRegion.center = addressCoordinates;
    myRegion.span = zoom;
    [ConvergeMapView setRegion:myRegion animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
