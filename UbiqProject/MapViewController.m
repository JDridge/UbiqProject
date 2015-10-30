//
//  MapViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 10/18/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import "MapViewController.h"
#import "Query.h"
#import "CustomAnnotation.h"
#import <MapKit/MapKit.h>
#import "SettingsModalViewController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController {
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
}
@synthesize ConvergeMapView, queryToShow, locationManager, addressCoordinates, FirstLocationSwitchOnOrOff, SecondLocationSwitchOnOrOff,annotationViewOfMap, commonPoints, firstLocationLatitude, firstLocationLongitude, secondLocationLatitude, secondLocationLongitude;

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    annotationViewOfMap.canShowCallout = YES;

    // Zoom the map to current location.
    [self.ConvergeMapView setShowsUserLocation:YES];
    [self.ConvergeMapView setUserInteractionEnabled:YES];
    [self.ConvergeMapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    MKPointAnnotation *firstAddressAnnotation = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *secondAddressAnnotation = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *halfwayAnnotation = [[MKPointAnnotation alloc] init];
    
    CustomAnnotation *firstCustomAnnotation = [[CustomAnnotation alloc] init];
    CustomAnnotation *secondCustomAnnotation = [[CustomAnnotation alloc] init];
    CustomAnnotation *halfwayCustomAnnotation = [[CustomAnnotation alloc] init];
    
    
    CLLocationCoordinate2D firstLocationPlacemarkCoordinates;
    
    if ([[queryToShow.locations objectAtIndex:0] isKindOfClass:[CLPlacemark class]]) {
        CLPlacemark *firstAddressPlacemark = [queryToShow.locations objectAtIndex:0];
        firstLocationPlacemarkCoordinates = CLLocationCoordinate2DMake(firstAddressPlacemark.location.coordinate.latitude, firstAddressPlacemark.location.coordinate.longitude);
    }
    else if([[queryToShow.locations objectAtIndex:0] isKindOfClass:[CLLocation class]]) {
        CLLocation *currentLocationFromUser = [queryToShow.locations objectAtIndex:0];
        firstLocationPlacemarkCoordinates = CLLocationCoordinate2DMake(currentLocationFromUser.coordinate.latitude, currentLocationFromUser.coordinate.longitude);
    }
    else { //If for some reason it gets here, set the first location coordinates to 0, 0. 
        firstLocationPlacemarkCoordinates = CLLocationCoordinate2DMake(0, 0);
    }

    CLPlacemark *secondAddressPlacemark = [queryToShow.locations objectAtIndex:1];
    
    CLLocationDegrees halfwayLatitude = (firstLocationPlacemarkCoordinates.latitude + secondAddressPlacemark.location.coordinate.latitude)/2.0;
    CLLocationDegrees halfwayLongitude = (firstLocationPlacemarkCoordinates.longitude + secondAddressPlacemark.location.coordinate.longitude)/2.0;
    
    CLLocationCoordinate2D halfwayCoordinates = CLLocationCoordinate2DMake(halfwayLatitude, halfwayLongitude);
    
    firstCustomAnnotation.name = @"1";
    secondCustomAnnotation.name = @"2";
    halfwayCustomAnnotation.name = @"3";
    
    
    firstAddressAnnotation.coordinate =
    CLLocationCoordinate2DMake(firstAddressPlacemark.location.coordinate.latitude, firstAddressPlacemark.location.coordinate.longitude);
   
    //new code
    firstLocationLatitude =  firstAddressAnnotation.coordinate.latitude;
    firstLocationLongitude = firstAddressAnnotation.coordinate.longitude;
    //end of new
    
    NSLog(@"*****first location latitude*****");
    NSLog(@"%f", firstLocationLatitude);
    
    
    secondAddressAnnotation.coordinate =
    CLLocationCoordinate2DMake(secondAddressPlacemark.location.coordinate.latitude, secondAddressPlacemark.location.coordinate.longitude);
    halfwayAnnotation.coordinate = halfwayCoordinates;
    
    
    
    //new code
    secondLocationLongitude = secondAddressAnnotation.coordinate.longitude;
    secondLocationLatitude = secondAddressAnnotation.coordinate.latitude;
    //end of new
    
    firstCustomAnnotation.coordinate =  CLLocationCoordinate2DMake(firstAddressPlacemark.location.coordinate.latitude, firstAddressPlacemark.location.coordinate.longitude);
    
    secondCustomAnnotation.coordinate =  CLLocationCoordinate2DMake(secondAddressPlacemark.location.coordinate.latitude, secondAddressPlacemark.location.coordinate.longitude);
    
    halfwayCustomAnnotation.coordinate = halfwayCoordinates;
    
    //loads all results from natural language queries
    [self loadPlacesFromNaturalLanguageQuery:halfwayCoordinates];
    
    
    [ConvergeMapView addAnnotation:firstCustomAnnotation];
    [ConvergeMapView addAnnotation:secondCustomAnnotation];
    [ConvergeMapView addAnnotation:halfwayCustomAnnotation];
    
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .3f; //the zoom level in degrees
    zoom.longitudeDelta = .3f;//the zoom level in degrees
    MKCoordinateRegion myRegion;
    myRegion.center = halfwayAnnotation.coordinate;
    myRegion.span = zoom;
    [ConvergeMapView setRegion:myRegion animated:YES];
    
}






-(void)loadPlacesFromNaturalLanguageQuery:(CLLocationCoordinate2D)halfwayCoordinates{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = commonPoints;
    request.region = MKCoordinateRegionMake(halfwayCoordinates,
                                            MKCoordinateSpanMake(0.125, 0.125));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
    
        NSMutableArray *placemarks = [NSMutableArray array];
        
        for (MKMapItem *item in response.mapItems) {
            MKPointAnnotation *updatedAnnotation = [[MKPointAnnotation alloc] init];
            updatedAnnotation.title = item.name;
            updatedAnnotation.coordinate = item.placemark.coordinate;
            updatedAnnotation.subtitle = item.placemark.title;
            [placemarks addObject:updatedAnnotation];
         
            }
        
        [self.ConvergeMapView showAnnotations:placemarks animated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingsButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"settingsVC" sender:nil];
}



- (void) loadConvergeMapViewForConvergedPoint {
    
    self.ConvergeMapView.delegate = self;
    addressCoordinates = [[queryToShow.locations objectAtIndex:0] coordinate];
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .01f; //the zoom level in degrees
    zoom.longitudeDelta = .01f;//the zoom level in degrees
    MKCoordinateRegion myRegion;
    myRegion.center = addressCoordinates;
    myRegion.span = zoom;
    [ConvergeMapView setRegion:myRegion animated:YES];
    
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *myLocation = (CustomAnnotation*) annotation;
        annotationViewOfMap = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Custom Annotation"];
        annotationViewOfMap.canShowCallout = YES;
        if(annotationViewOfMap == nil) {
            annotationViewOfMap = myLocation.annotationView;
        }
        if (([((CustomAnnotation *)annotation).name isEqualToString: @"1"])){
            annotationViewOfMap.image=[UIImage imageNamed:@"Icons/smallCHRIS.png"];
        }
        if (([((CustomAnnotation *)annotation).name isEqualToString: @"2"])){
            annotationViewOfMap.image=[UIImage imageNamed:@"Icons/smallJOSEPH.png"];
        }
        if (([((CustomAnnotation *)annotation).name isEqualToString: @"3"])){
            annotationViewOfMap.image=[UIImage imageNamed:@"Icons/halfwayarrow.png"];
        }
        else {
            annotationViewOfMap.annotation = annotation;
        }
        return annotationViewOfMap;
    }
    else {
        return nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SettingsModalViewController *viewController = [segue destinationViewController];
    viewController.printQuery = queryToShow;
    
    viewController.firstLocationLatitude = firstLocationLatitude;
    viewController.firstLocationLongitude = firstLocationLongitude;
    viewController.secondLocationLatitude = secondLocationLatitude;
    viewController.secondLocationLongitude = secondLocationLongitude;
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
