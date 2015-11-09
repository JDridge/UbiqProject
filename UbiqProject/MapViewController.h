//
//  MapViewController.h
//  UbiqProject
//
//  Created by Robert Vo on 10/18/15.
//  Copyright © 2015 Joey. All rights reserved.
//
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Query.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *ConvergeMapView;
@property Query *queryToShow;
@property MKAnnotationView *annotationViewOfMap;

- (IBAction)settingsButtonClick:(id)sender;

- (void) loadConvergeMapViewForConvergedPoint:(MKPointAnnotation *)annotation;
- (void) loadPlacesFromNaturalLanguageQuery:(CLLocationCoordinate2D) halfwayCoordinates;
- (CLLocationCoordinate2D)locationPlacemarkCoordinatesFactoryMethod:(id)locationCoordinates;

@end
