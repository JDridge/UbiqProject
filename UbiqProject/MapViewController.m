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
@synthesize ConvergeMapView, queryToShow, locationManager, addressCoordinates, FirstLocationSwitchOnOrOff,annotationViewOfMap, commonPoints;

- (void)viewDidLoad {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    annotationViewOfMap.canShowCallout = YES;
    // self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.searchDisplayController setDelegate:self];
    [self.ibSearchBar setDelegate:self];
    self.locationManager= [[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    [self.locationManager requestAlwaysAuthorization];
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
    else {
        firstLocationPlacemarkCoordinates = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    }

    
    
    CLPlacemark *secondAddressPlacemark = [queryToShow.locations objectAtIndex:1];
    
    CLLocationDegrees halfwayLatitude = (firstLocationPlacemarkCoordinates.latitude + secondAddressPlacemark.location.coordinate.latitude)/2.0;
    CLLocationDegrees halfwayLongitude = (firstLocationPlacemarkCoordinates.longitude + secondAddressPlacemark.location.coordinate.longitude)/2.0;
    
    CLLocationCoordinate2D halfwayCoordinates = CLLocationCoordinate2DMake(halfwayLatitude, halfwayLongitude);
    
    firstCustomAnnotation.name = @"1";
    secondCustomAnnotation.name = @"2";
    halfwayCustomAnnotation.name = @"3";
    
    firstAddressAnnotation.coordinate = CLLocationCoordinate2DMake(firstLocationPlacemarkCoordinates.latitude, firstLocationPlacemarkCoordinates.longitude);
    secondAddressAnnotation.coordinate =
    CLLocationCoordinate2DMake(secondAddressPlacemark.location.coordinate.latitude, secondAddressPlacemark.location.coordinate.longitude);
    halfwayAnnotation.coordinate = halfwayCoordinates;
    
    
    firstCustomAnnotation.coordinate =  CLLocationCoordinate2DMake(firstLocationPlacemarkCoordinates.latitude, firstLocationPlacemarkCoordinates.longitude);
    
    secondCustomAnnotation.coordinate =  CLLocationCoordinate2DMake(secondAddressPlacemark.location.coordinate.latitude, secondAddressPlacemark.location.coordinate.longitude);
    
    halfwayCustomAnnotation.coordinate = halfwayCoordinates;
    
    //loads all results from natural language queries
    [self loadPlacesFromNaturalLanguageQuery:halfwayCoordinates];
    
    
    //new code
    double lat = firstLocationPlacemarkCoordinates.latitude;
    double lon = firstLocationPlacemarkCoordinates.longitude;
    
    NSLog(@"lat = %f", lat);
    NSLog(@"lat = %f", lon);
    
    NSLog(@"first switch = %d", FirstLocationSwitchOnOrOff);
    
    //end of new code
    
    
    //    [ConvergeMapView addAnnotation:firstAddressAnnotation];
    //    [ConvergeMapView addAnnotation:secondAddressAnnotation];
    //    [ConvergeMapView addAnnotation:halfwayAnnotation];
    
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
    

    //NSLog([NSString stringWithFormat:@"%f", [queryToShow.locations objectAtIndex:0]]);
    //[self loadConvergeMapViewForConvergedPoint];
    // Do any additional setup after loading the view.
    
    //if statement using current location.
    
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

- (void) loadMapAtCurrentLocation { //use this snippet to load the map at the current location.
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Cancel any previous searches.
    [localSearch cancel];
    
    // Perform a new search.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.ConvergeMapView.region;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        results = response;
        
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results.mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
    }
    
    MKMapItem *item = results.mapItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchDisplayController setActive:NO animated:YES];
    
    MKMapItem *item = results.mapItems[indexPath.row];
    [self.ConvergeMapView addAnnotation:item.placemark];
    [self.ConvergeMapView selectAnnotation:item.placemark animated:YES];
    
    [self.ConvergeMapView setCenterCoordinate:item.placemark.location.coordinate animated:YES];
    
    [self.ConvergeMapView setUserTrackingMode:MKUserTrackingModeNone];
    
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
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
