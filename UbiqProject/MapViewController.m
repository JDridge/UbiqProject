#import "MapViewController.h"
#import "Query.h"
#import "CustomAnnotation.h"
#import <MapKit/MapKit.h>
#import "SettingsModalViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize ConvergeMapView, queryToShow, annotationViewOfMap, didFinishLoading, numberOfLocations;

- (void)viewDidLoad {
    didFinishLoading = NO;
    [super viewDidLoad];
    [self setUpConvergeMapView];
    [self createTheCustomAnnotations];
}

- (void)setUpConvergeMapView {
    [self.ConvergeMapView setShowsUserLocation:YES];
    [self.ConvergeMapView setUserInteractionEnabled:YES];
    [self.ConvergeMapView setUserTrackingMode:MKUserTrackingModeFollow];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    annotationViewOfMap.canShowCallout = YES;
}

- (void) createTheCustomAnnotations {
//    for (int i = 0; i < numberOfLocations; i++) {
//        CustomAnnotation *thisCustomAnnotation = [[CustomAnnotation alloc] init];
//        CLLocationCoordinate2D thisLocationPlacemark = [self locationPlacemarkCoordinatesFactoryMethod:[queryToShow.locations objectAtIndex:i]];
//        thisCustomAnnotation.name = [NSString stringWithFormat:@"%i", i];
//        thisCustomAnnotation.coordinate = thisLocationPlacemark;
//        [ConvergeMapView addAnnotation:thisCustomAnnotation];
//    }
    CustomAnnotation *firstCustomAnnotation = [[CustomAnnotation alloc] init];
    CustomAnnotation *secondCustomAnnotation = [[CustomAnnotation alloc] init];
    CustomAnnotation *halfwayCustomAnnotation = [[CustomAnnotation alloc] init];
    
    CLLocationCoordinate2D firstLocationPlacemarkCoordinates = [self locationPlacemarkCoordinatesFactoryMethod:[queryToShow.locations objectAtIndex:0]];
    CLLocationCoordinate2D secondLocationPlacemarkCoordinates = [self locationPlacemarkCoordinatesFactoryMethod:[queryToShow.locations objectAtIndex:1]];
    
    firstCustomAnnotation.name = @"1";
    secondCustomAnnotation.name = @"2";
    halfwayCustomAnnotation.name = @"3";
    
    firstCustomAnnotation.coordinate = firstLocationPlacemarkCoordinates;
    secondCustomAnnotation.coordinate = secondLocationPlacemarkCoordinates;
    halfwayCustomAnnotation.coordinate = [self getHalfwayCoordinates:firstLocationPlacemarkCoordinates secondLocation:secondLocationPlacemarkCoordinates];
    
    while(!didFinishLoading) {
        [self displayAnimationForLoading];
        [self loadPlacesFromNaturalLanguageQuery:halfwayCustomAnnotation.coordinate];
    }
    
    [ConvergeMapView addAnnotation:firstCustomAnnotation];
    [ConvergeMapView addAnnotation:secondCustomAnnotation];
    [ConvergeMapView addAnnotation:halfwayCustomAnnotation];
    
    [self loadConvergeMapViewForConvergedPoint:halfwayCustomAnnotation];
    
    //[self getHalfwayCoordinates:@[@"hi", @"hi"]];
}

- (void) displayAnimationForLoading {
    NSLog(@"Display animation here.");
}

- (CLLocationCoordinate2D)getHalfwayCoordinates:(NSArray*)allLocations numberOfLocations:(int)locationsCount {
    float allLatitudes = 0;
    float allLongitudes = 0;
    
    for (NSObject *thisLocation in allLocations) {
        if([thisLocation isKindOfClass:[CLLocation class]]) {
            CLLocation *thisLocationAsCLLocation = (CLLocation*) thisLocation;
            allLatitudes += thisLocationAsCLLocation.coordinate.latitude;
            allLongitudes += thisLocationAsCLLocation.coordinate.longitude;
        }
    }
    
    return CLLocationCoordinate2DMake(allLatitudes/locationsCount, allLongitudes/locationsCount);
}

- (CLLocationCoordinate2D)getHalfwayCoordinates:(CLLocationCoordinate2D)firstLocation secondLocation:(CLLocationCoordinate2D)secondLocation {
    CLLocationDegrees halfwayLatitude = (firstLocation.latitude + secondLocation.latitude)/2.0;
    CLLocationDegrees halfwayLongitude = (firstLocation.longitude + secondLocation.longitude)/2.0;
    return CLLocationCoordinate2DMake(halfwayLatitude, halfwayLongitude);
}


- (void)loadConvergeMapViewForConvergedPoint:(CustomAnnotation *)annotation {
    MKCoordinateSpan zoom;
    zoom.latitudeDelta = .3f;
    zoom.longitudeDelta = .3f;
    MKCoordinateRegion myRegion;
    myRegion.center = annotation.coordinate;
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
}

#pragma I changed this load CustomAnnotation pins. I think we should create another set of custom annotations instead.
-(void)loadPlacesFromNaturalLanguageQuery:(CLLocationCoordinate2D)halfwayCoordinates{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = queryToShow.category;
    
    //one degree of latitude is always approximately 111 kilometers (69 miles)
    request.region = MKCoordinateRegionMake(halfwayCoordinates,
                                            MKCoordinateSpanMake(0.00289855, 0.00289855));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];

    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSMutableArray *placemarks = [NSMutableArray array];
        
        for (MKMapItem *item in response.mapItems) {
            CustomAnnotation *updatedCustomAnnotation = [[CustomAnnotation alloc] initWithTitleCoordinateSubtitle:item.name Location:item.placemark.coordinate subtitle:item.placemark.title];
            [placemarks addObject:updatedCustomAnnotation];
        }
        [self.ConvergeMapView showAnnotations:placemarks animated:YES];
    }];
    didFinishLoading = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *myLocation = (CustomAnnotation*) annotation;
        annotationViewOfMap = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Custom Annotation"];
        annotationViewOfMap.canShowCallout = YES;
        if(annotationViewOfMap == nil) {
            annotationViewOfMap = myLocation.annotationView;
        }
        if (([myLocation.name isEqualToString: @"1"])){
            annotationViewOfMap.image = [UIImage imageNamed:@"smallCHRIS"];
        }
        if (([myLocation.name isEqualToString: @"2"])){
            annotationViewOfMap.image = [UIImage imageNamed:@"smallJOSEPH"];
        }
        if (([myLocation.name isEqualToString: @"3"])){
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SettingsModalViewController *viewController = (SettingsModalViewController *) segue.destinationViewController;
    viewController.printQuery = queryToShow;
}


#pragma Called when the right callout is tapped, which is shown after you click on the pin and the halfway icon in the bubble.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Converge"
                                message:[NSString stringWithFormat:@"You have selected %@", ((CustomAnnotation*)view.annotation).title]
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

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"done loading map!");
}




@end
