//
//  MapViewController.m
//  UbiqProject
//
//  Created by Robert Vo on 10/18/15.
//  Copyright © 2015 Joey. All rights reserved.
//
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
@synthesize ConvergeMapView, queryToShow, locationManager, addressCoordinates, annotationViewOfMap, commonPoints, firstLocationLatitude, firstLocationLongitude, secondLocationLatitude, secondLocationLongitude;

# warning The method for viewDidLoad is extremely long. Try condensing the functionality into other (new) methods.
- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    annotationViewOfMap.canShowCallout = YES;

    [self.ConvergeMapView setShowsUserLocation:YES];
    [self.ConvergeMapView setUserInteractionEnabled:YES];
    [self.ConvergeMapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    MKPointAnnotation *firstAddressAnnotation = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *secondAddressAnnotation = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *halfwayAnnotation = [[MKPointAnnotation alloc] init];
    
    CustomAnnotation *firstCustomAnnotation = [[CustomAnnotation alloc] init];
    CustomAnnotation *secondCustomAnnotation = [[CustomAnnotation alloc] init];
    CustomAnnotation *halfwayCustomAnnotation = [[CustomAnnotation alloc] init];
    
    CLLocationCoordinate2D firstLocationPlacemarkCoordinates = [self locationPlacemarkCoordinatesFactoryMethod:[queryToShow.locations objectAtIndex:0]];
    CLLocationCoordinate2D secondLocationPlacemarkCoordinates = [self locationPlacemarkCoordinatesFactoryMethod:[queryToShow.locations objectAtIndex:1]];
    
    //new code
    # warning What is going on here? Why is there firstLocationPlacemarkCoordinates and firstAddressPlacemark?
    CLPlacemark *firstAddressPlacemark = [queryToShow.locations objectAtIndex:1];
    //end of new code
    CLPlacemark *secondAddressPlacemark = [queryToShow.locations objectAtIndex:1];
    
    CLLocationDegrees halfwayLatitude = (firstLocationPlacemarkCoordinates.latitude + secondLocationPlacemarkCoordinates.latitude)/2.0;
    CLLocationDegrees halfwayLongitude = (firstLocationPlacemarkCoordinates.longitude + secondLocationPlacemarkCoordinates.longitude)/2.0;
    
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
    
    
    secondAddressAnnotation.coordinate = CLLocationCoordinate2DMake(secondAddressPlacemark.location.coordinate.latitude, secondAddressPlacemark.location.coordinate.longitude);
    halfwayAnnotation.coordinate = halfwayCoordinates;
    
    //new code
    secondLocationLongitude = secondAddressAnnotation.coordinate.longitude;
    secondLocationLatitude = secondAddressAnnotation.coordinate.latitude;
    //end of new
    
    firstCustomAnnotation.coordinate = CLLocationCoordinate2DMake(firstAddressPlacemark.location.coordinate.latitude, firstAddressPlacemark.location.coordinate.longitude);
    secondCustomAnnotation.coordinate = CLLocationCoordinate2DMake(secondAddressPlacemark.location.coordinate.latitude, secondAddressPlacemark.location.coordinate.longitude);
    halfwayCustomAnnotation.coordinate = halfwayCoordinates;
    
    //loads all results from natural language queries
    [self loadPlacesFromNaturalLanguageQuery:halfwayCoordinates];
    
    [ConvergeMapView addAnnotation:firstCustomAnnotation];
    [ConvergeMapView addAnnotation:secondCustomAnnotation];
    [ConvergeMapView addAnnotation:halfwayCustomAnnotation];
    
    //Put logic into loadConvergeMapViewForConvergedPoint.
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .3f; //the zoom level in degrees
    zoom.longitudeDelta = .3f;//the zoom level in degrees
    MKCoordinateRegion myRegion;
    myRegion.center = halfwayAnnotation.coordinate;
    myRegion.span = zoom;
    [ConvergeMapView setRegion:myRegion animated:YES];
    
}

- (CLLocationCoordinate2D)locationPlacemarkCoordinatesFactoryMethod:(id)locationCoordinates {
    if ([locationCoordinates isKindOfClass:[CLPlacemark class]]) {
        CLPlacemark *addressPlacemark = (CLPlacemark*) locationCoordinates;
        return CLLocationCoordinate2DMake(addressPlacemark.location.coordinate.latitude, addressPlacemark.location.coordinate.longitude);
    }
    else if([locationCoordinates isKindOfClass:[CLLocation class]]) {
        CLLocation *currentLocationFromUser = (CLLocation*) locationCoordinates;
        return CLLocationCoordinate2DMake(currentLocationFromUser.coordinate.latitude, currentLocationFromUser.coordinate.longitude);
    }
    else { //If for some reason it gets here, set the first location coordinates to 0, 0.
        return CLLocationCoordinate2DMake(0, 0);
    }
    return CLLocationCoordinate2DMake(0, 0);
}


-(void)loadPlacesFromNaturalLanguageQuery:(CLLocationCoordinate2D)halfwayCoordinates{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = commonPoints;
    
    //one degree of latitude is always approximately 111 kilometers (69 miles)
    request.region = MKCoordinateRegionMake(halfwayCoordinates,
                                            MKCoordinateSpanMake(0.00289855, 0.00289855));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSMutableArray *placemarks = [NSMutableArray array];
        
        for (MKMapItem *item in response.mapItems) {
            CustomAnnotation *updatedCustomAnnotation = [[CustomAnnotation alloc] init];
            updatedCustomAnnotation.title = item.name;
            updatedCustomAnnotation.coordinate = item.placemark.coordinate;
            updatedCustomAnnotation.subtitle = item.placemark.title;
            [placemarks addObject:updatedCustomAnnotation];
        }
        
        [self.ConvergeMapView showAnnotations:placemarks animated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# warning unused at the moment.
- (void) loadConvergeMapViewForConvergedPoint {
    ConvergeMapView.delegate = self;
    addressCoordinates = [[queryToShow.locations objectAtIndex:0] coordinate];
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .01f; //the zoom level in degrees
    zoom.longitudeDelta = .01f;//the zoom level in degrees
    MKCoordinateRegion myRegion;
    myRegion.center = addressCoordinates;
    myRegion.span = zoom;
    [ConvergeMapView setRegion:myRegion animated:YES];
    
}

# warning Cleaup ((CustomAnnotation*).annotation).name is reused too many times. Don't repeat yourself.
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *myLocation = (CustomAnnotation*) annotation;
        annotationViewOfMap = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Custom Annotation"];
        annotationViewOfMap.canShowCallout = YES;
        if(annotationViewOfMap == nil) {
            annotationViewOfMap = myLocation.annotationView;
        }
        if (([((CustomAnnotation *)annotation).name isEqualToString: @"1"])){
            annotationViewOfMap.image = [UIImage imageNamed:@"smallCHRIS"];
        }
        if (([((CustomAnnotation *)annotation).name isEqualToString: @"2"])){
            annotationViewOfMap.image = [UIImage imageNamed:@"smallJOSEPH"];
        }
        if (([((CustomAnnotation *)annotation).name isEqualToString: @"3"])){
            annotationViewOfMap.image = [UIImage imageNamed:@"halfwayarrow"];
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

- (IBAction)settingsButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"settingsVC" sender:nil];
}

# warning These variables are being set arbitrarily in the viewDidLoad method. Why not synthesize them?
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SettingsModalViewController *viewController = [segue destinationViewController];
    viewController.printQuery = queryToShow;
    viewController.firstLocationLatitude = firstLocationLatitude;
    viewController.firstLocationLongitude = firstLocationLongitude;
    viewController.secondLocationLatitude = secondLocationLatitude;
    viewController.secondLocationLongitude = secondLocationLongitude;
}


#pragma Called when the right callout is tapped, which is shown after you click on the pin and the halfway icon in the bubble.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CustomAnnotation *selectedPin = (CustomAnnotation*) view.annotation;
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Converge"
                                message:[NSString stringWithFormat:@"You have selected %@", selectedPin.title]
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayButton = [UIAlertAction
                                 actionWithTitle:@"Okay"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
    [alert addAction:okayButton];
    [self presentViewController:alert animated:YES completion:nil];

}



@end
