#import "MapViewController.h"
#import "Query.h"
#import "CustomAnnotation.h"
#import "UserCustomAnnotation.h"
#import "SearchCustomAnnotation.h"
#import <MapKit/MapKit.h>
#import "SettingsModalViewController.h"
#import "MapDetailedViewController.h"

@interface MapViewController () {
    NSMutableArray *allLocations;
}

@end

@implementation MapViewController

@synthesize ConvergeMapView, queryToShow, annotationViewOfMap, didFinishLoading, numberOfLocations;

- (void)viewDidLoad {
    didFinishLoading = NO;
    [super viewDidLoad];
    [self setUpConvergeMapView];
    [self createTheCustomAnnotations];
    
    [self.ConvergeMapView showAnnotations:allLocations animated:YES];
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
    
    CLLocationCoordinate2D firstLocationPlacemarkCoordinates = [self locationPlacemarkCoordinatesFactoryMethod:[queryToShow.locations objectAtIndex:0]];
    CLLocationCoordinate2D secondLocationPlacemarkCoordinates = [self locationPlacemarkCoordinatesFactoryMethod:[queryToShow.locations objectAtIndex:1]];
    CLLocationCoordinate2D halfwayPlaceMarkCoordinates = [self getHalfwayCoordinates:firstLocationPlacemarkCoordinates secondLocation:secondLocationPlacemarkCoordinates];
    
    CustomAnnotation *firstCustomAnnotation = [[UserCustomAnnotation alloc]
                                               initWithTitleCoordinateSubtitle:@"Joseph"
                                               Location:firstLocationPlacemarkCoordinates
                                               subtitle:@"Joseph's address"];
    
    CustomAnnotation *secondCustomAnnotation = [[UserCustomAnnotation alloc]
                                                initWithTitleCoordinateSubtitle:@"Chris"
                                                Location:secondLocationPlacemarkCoordinates
                                                subtitle:@"Chris' address"];
    
    CustomAnnotation *halfwayCustomAnnotation = [[CustomAnnotation alloc]
                                                 initWithTitleCoordinateSubtitle:@"Halfway Point"
                                                 Location:halfwayPlaceMarkCoordinates
                                                 subtitle:@"Halfway address"];
    while(!didFinishLoading) {
        [self displayAnimationForLoading];
        [self loadPlacesFromNaturalLanguageQuery:halfwayCustomAnnotation.coordinate]; //Apple Maps Query
//        [self loadPlacesFromYelp:halfwayCustomAnnotation.coordinate];               //Yelp Query
    }
    
    [ConvergeMapView addAnnotation:firstCustomAnnotation];
    [ConvergeMapView addAnnotation:secondCustomAnnotation];
    [ConvergeMapView addAnnotation:halfwayCustomAnnotation];
    
    [self loadConvergeMapViewForConvergedPoint:halfwayCustomAnnotation];
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
    
    request.region = MKCoordinateRegionMake(halfwayCoordinates, [self filterDistance:10 inUnitsOf:@"mi"]);
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];

    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        NSMutableArray *placemarks = [NSMutableArray array];
        
        for (MKMapItem *item in response.mapItems) {
            CustomAnnotation *updatedCustomAnnotation = [[SearchCustomAnnotation alloc] initWithTitleCoordinateSubtitle:item.name Location:item.placemark.coordinate subtitle:item.placemark.title];
            [placemarks addObject:updatedCustomAnnotation];
        }
        [self.ConvergeMapView showAnnotations:placemarks animated:YES];
    }];
    didFinishLoading = YES;
}

-(void)loadPlacesFromYelp:(CLLocationCoordinate2D) halfwayCoordinates {
    @autoreleasepool {
        NSString *defaultTerm = queryToShow.category;
        NSString *defaultCoordinates = [NSString stringWithFormat:@"%f,%f", halfwayCoordinates.latitude, halfwayCoordinates.longitude];
    
        //Get the term and location from the command line if there were any, otherwise assign default values.
        NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
        NSString *ll = [[NSUserDefaults standardUserDefaults] valueForKey:@"ll"] ?: defaultCoordinates;
        
        
        YPAPISample *APISample = [[YPAPISample alloc] init];
        
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        [APISample queryTopBusinessInfoForTerm:term ll:ll completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
//        https://api.yelp.com/v2/search?term=german+food&location=Hayes&cll=37.77493,-122.419415
            NSString *yelpSearch = [NSString stringWithFormat:@"https://api.yelp.com/v2/search?term=%@&cll=%f,%f", queryToShow.category, halfwayCoordinates.latitude, halfwayCoordinates.longitude
                                    ];
            NSLog(@"%f, %f", halfwayCoordinates.latitude, halfwayCoordinates.longitude);
            NSLog(@"%@", yelpSearch);
            if (error) {
                NSLog(@"An error happened during the request: %@", error);
            } else if (topBusinessJSON) {
//                for (MKMapItem *item in response.mapItems) {
//                    CustomAnnotation *updatedCustomAnnotation = [[SearchCustomAnnotation alloc] initWithTitleCoordinateSubtitle:item.name Location:item.placemark.coordinate subtitle:item.placemark.title];
//                    [placemarks addObject:updatedCustomAnnotation];
                
//
                NSLog(@"Top business info: \n %@", topBusinessJSON);
//                nameLabel.text = [topBusinessJSON objectForKey:@"name"];
//                phoneLabel.text = [NSString stringWithFormat:@"%@%@", @"Phone Number: ", [topBusinessJSON objectForKey:@"phone"]];
                
                NSArray *addressObject = [[topBusinessJSON objectForKey:@"location"] objectForKey:@"display_address"];
                
                NSString *stringAddress = @"";
                for(int i = 0; i < [addressObject count]; i++) {
                    stringAddress = [stringAddress stringByAppendingString:[NSString stringWithFormat:@"%@\n", addressObject[i]]];
                }
                
//                addressLabel.text = stringAddress;
//                
//                reviewCountLabel.text = [NSString stringWithFormat:@"%@%i", @"Reviews: ",[[topBusinessJSON objectForKey:@"review_count"] intValue]];
//                
//                
//                yelpURL =[topBusinessJSON objectForKey:@"url"];
                //po [topBusinessJSON objectForKey:@"url"]
                
                
                
                
                
                
            } else {
                NSLog(@"No business was found");
            }
            
            dispatch_group_leave(requestGroup);
        }];
        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    }

}
/*
 
 @autoreleasepool {
 NSString *defaultTerm = category;
 NSString *defaultCoordinates = [NSString stringWithFormat:@"%f,%f", pinLocation.coordinate.latitude, pinLocation.coordinate.longitude];
 
 //Get the term and location from the command line if there were any, otherwise assign default values.
 NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
 NSString *ll = [[NSUserDefaults standardUserDefaults] valueForKey:@"ll"] ?: defaultCoordinates;
 
 
 YPAPISample *APISample = [[YPAPISample alloc] init];
 
 dispatch_group_t requestGroup = dispatch_group_create();
 
 dispatch_group_enter(requestGroup);
 [APISample queryTopBusinessInfoForTerm:term ll:ll completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
 
 if (error) {
 NSLog(@"An error happened during the request: %@", error);
 } else if (topBusinessJSON) {
 //TODO - assign yelpURL
 //TODO - set labels for result
 
 NSLog(@"Top business info: \n %@", topBusinessJSON);
 nameLabel.text = [topBusinessJSON objectForKey:@"name"];
 phoneLabel.text = [NSString stringWithFormat:@"%@%@", @"Phone Number: ", [topBusinessJSON objectForKey:@"phone"]];
 
 NSArray *addressObject = [[topBusinessJSON objectForKey:@"location"] objectForKey:@"display_address"];
 
 NSString *stringAddress = @"";
 for(int i = 0; i < [addressObject count]; i++) {
 stringAddress = [stringAddress stringByAppendingString:[NSString stringWithFormat:@"%@\n", addressObject[i]]];
 }
 
 addressLabel.text = stringAddress;
 
 reviewCountLabel.text = [NSString stringWithFormat:@"%@%i", @"Reviews: ",[[topBusinessJSON objectForKey:@"review_count"] intValue]];
 
 
 yelpURL =[topBusinessJSON objectForKey:@"url"];
 //po [topBusinessJSON objectForKey:@"url"]
 
 
 
 
 
 
 } else {
 NSLog(@"No business was found");
 }
 
 dispatch_group_leave(requestGroup);
 }];
 dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
 }
 
 */

-(MKCoordinateSpan)filterDistance:(double)distance inUnitsOf:(NSString *)metricUnit {
    float convertedUnit;
    
    if ([metricUnit isEqualToString:@"mi"])
        convertedUnit = [self convertMilesToDegrees:distance];
    else if ([metricUnit isEqualToString:@"km"])
        convertedUnit = [self convertKilometersToDegrees:distance];
    else
        convertedUnit = (2/69.0); // 2 mile radius by default
    
    return MKCoordinateSpanMake(convertedUnit, convertedUnit);
}

-(double)convertMilesToDegrees:(double)miles { return miles/69.0; }

-(double)convertKilometersToDegrees:(double)kilometers { return kilometers/111.0; }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[CustomAnnotation class]]){
        MKAnnotationView *annotationView;
        CustomAnnotation *location;
        
        if ([annotation isKindOfClass:[UserCustomAnnotation class]]) {
            location = (UserCustomAnnotation *) annotation;
            annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"UserCustomAnnotation"];
        } else if ([annotation isKindOfClass:[SearchCustomAnnotation class]]){
            location = (SearchCustomAnnotation *) annotation;
            annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"SearchCustomAnnotation"];
        } else {
            location = (CustomAnnotation *) annotation;
            annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        }
        
        if (annotationView == nil)
            annotationView = location.annotationView;
        else
            annotationView.annotation = annotation;
        
        return annotationView;
    } else
        return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MapDetailedViewController *vc = [segue destinationViewController];
    vc.pinLocation = ((MKAnnotationView *)sender).annotation;
    vc.category = queryToShow.category;
    
}

#pragma Called when the right callout is tapped, which is shown after you click on the pin and the halfway icon in the bubble.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([view.annotation isKindOfClass:[UserCustomAnnotation class]]){
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Converge"
                                    message:[NSString stringWithFormat:@"%@ phone number here", ((CustomAnnotation*)view.annotation).title]
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okayButton = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
        [alert addAction:okayButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([view.annotation isKindOfClass:[SearchCustomAnnotation class]]) 
        [self performSegueWithIdentifier:@"MapDetailedVC" sender:view];
    else
         NSLog(@"Balls!!!");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"done loading map!");
}

@end
