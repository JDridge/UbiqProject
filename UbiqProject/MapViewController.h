#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Query.h"
#import "CustomAnnotation.h"
#import <Parse/Parse.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *ConvergeMapView;
@property Query *queryToShow;
@property MKAnnotationView *annotationViewOfMap;
@property BOOL didFinishLoading;
@property NSUInteger const numberOfLocations;

@property PFObject *friendsUserInfo;



- (void) loadConvergeMapViewForConvergedPoint:(CustomAnnotation *)annotation;
- (void) loadPlacesFromNaturalLanguageQuery:(CLLocationCoordinate2D) halfwayCoordinates;
- (CLLocationCoordinate2D)locationPlacemarkCoordinatesFactoryMethod:(id)locationCoordinates;
- (CLLocationCoordinate2D)getHalfwayCoordinates:(CLLocationCoordinate2D)firstLocation secondLocation:(CLLocationCoordinate2D)secondLocation;
- (MKCoordinateSpan)filterDistance:(double)distance inUnitsOf:(NSString *)metricUnit;
- (double)convertMilesToDegrees:(double)miles;
- (double)convertKilometersToDegrees:(double)kilometers;

@end
