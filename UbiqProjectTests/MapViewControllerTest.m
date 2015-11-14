#import <XCTest/XCTest.h>
#import "MapViewController.h"

@interface MapViewControllerTest : XCTestCase {
    MapViewController *mapVC;
}

@end

@implementation MapViewControllerTest

- (void)setUp {
    [super setUp];
    mapVC = [[MapViewController alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testCurrentLocationObjectAsLocationPlacemarkCoordinates {
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:28.00 longitude:92.00];
    XCTAssertTrue(CLLocationCoordinate2DIsValid([mapVC locationPlacemarkCoordinatesFactoryMethod:currentLocation]));
}

- (void) testInvalidObjectAsLocationPlacemarkCoordinates {
    NSObject *invalidObject;
    XCTAssertTrue(CLLocationCoordinate2DIsValid([mapVC locationPlacemarkCoordinatesFactoryMethod:invalidObject]));
}

- (void) testGetHalfwayCoordinatesForOneLocationWithCLLocation {
    CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    NSArray *allLocations = @[aLocation];
    XCTAssertTrue(CLLocationCoordinate2DMake(0, 0).longitude == [mapVC getHalfwayCoordinates:allLocations].longitude
                  && CLLocationCoordinate2DMake(0, 0).latitude == [mapVC getHalfwayCoordinates:allLocations].longitude);
}

- (void) testGetHalfwayCoordinatesForTwoLocationsUsingCLLocationCoordinate2D {
    CLLocationCoordinate2D firstLocation = CLLocationCoordinate2DMake(10, 10);
    CLLocationCoordinate2D secondLocation = CLLocationCoordinate2DMake(-10, -10);
    
    NSMutableArray *allLocations = [NSMutableArray array];
    [allLocations addObject:[[CLLocation alloc] initWithLatitude:firstLocation.latitude longitude:firstLocation.longitude]];
    [allLocations addObject:[[CLLocation alloc] initWithLatitude:secondLocation.latitude longitude:secondLocation.longitude]];
    
    XCTAssertTrue(CLLocationCoordinate2DMake(0, 0).longitude == [mapVC getHalfwayCoordinates:allLocations].longitude
                  && CLLocationCoordinate2DMake(0, 0).latitude == [mapVC getHalfwayCoordinates:allLocations].latitude);
}

@end
