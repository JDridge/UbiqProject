#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Query.h"
#import "CustomAnnotation.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *ConvergeMapView;
@property Query *queryToShow;
@property NSMutableArray* listOfCoordinates;
@property MKAnnotationView *annotationViewOfMap;
@property BOOL didFinishLoading;
@property NSUInteger const numberOfLocations;


- (void) loadConvergeMapViewForConvergedPoint:(CustomAnnotation *)annotation;
- (void) loadPlacesFromNaturalLanguageQuery:(CLLocationCoordinate2D) halfwayCoordinates;
- (CLLocationCoordinate2D)locationPlacemarkCoordinatesFactoryMethod:(id)locationCoordinates;
- (CLLocationCoordinate2D)getHalfwayCoordinates:(NSArray*)allLocations numberOfLocations:(int)locationsCount;

@end
