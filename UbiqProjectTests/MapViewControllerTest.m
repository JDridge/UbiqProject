#import <XCTest/XCTest.h>
#import "MapViewController.h"
#define kDeltaValue (0.00001)

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
    
    CLLocationCoordinate2D coordinatesForZeroZero = CLLocationCoordinate2DMake(0, 0);
    CLLocationCoordinate2D halfwayCoordinates = [mapVC getHalfwayCoordinates:allLocations numberOfLocations:(int) [allLocations count]];
    XCTAssertTrue(coordinatesForZeroZero.longitude == halfwayCoordinates.longitude
                  && coordinatesForZeroZero.latitude == halfwayCoordinates.longitude);
}

- (void) testGetHalfwayCoordinatesForTwoLocationsUsingCLLocationCoordinate2D {
    CLLocationCoordinate2D firstLocation = CLLocationCoordinate2DMake(10, 10);
    CLLocationCoordinate2D secondLocation = CLLocationCoordinate2DMake(-10, -10);
    
    NSMutableArray *allLocations = [NSMutableArray array];
    [allLocations addObject:[[CLLocation alloc] initWithLatitude:firstLocation.latitude longitude:firstLocation.longitude]];
    [allLocations addObject:[[CLLocation alloc] initWithLatitude:secondLocation.latitude longitude:secondLocation.longitude]];
    
    CLLocationCoordinate2D coordinatesForZeroZero = CLLocationCoordinate2DMake(0, 0);
    CLLocationCoordinate2D halfwayCoordinates = [mapVC getHalfwayCoordinates:allLocations numberOfLocations:(int) [allLocations count]];
    XCTAssertTrue(coordinatesForZeroZero.longitude == halfwayCoordinates.longitude
                  && coordinatesForZeroZero.latitude == halfwayCoordinates.longitude);
}

- (void) testGetHalfwayCoordinatesForThreeLocations {
    CLLocationCoordinate2D firstLocation = CLLocationCoordinate2DMake(50.2, 20.1);
    CLLocationCoordinate2D secondLocation = CLLocationCoordinate2DMake(40.456, 0.54634563);
    CLLocationCoordinate2D thirdLocation = CLLocationCoordinate2DMake(12.456, 20.54634563);

    NSMutableArray *allLocations = [NSMutableArray array];
    [allLocations addObject:[[CLLocation alloc] initWithLatitude:firstLocation.latitude longitude:firstLocation.longitude]];
    [allLocations addObject:[[CLLocation alloc] initWithLatitude:secondLocation.latitude longitude:secondLocation.longitude]];
    [allLocations addObject:[[CLLocation alloc] initWithLatitude:thirdLocation.latitude longitude:thirdLocation.longitude]];

    CLLocationCoordinate2D expectedHalfwayCoordinates = CLLocationCoordinate2DMake((firstLocation.latitude + secondLocation.latitude + thirdLocation.latitude)/3, (firstLocation.longitude + secondLocation.longitude + thirdLocation.longitude)/3);
    CLLocationCoordinate2D calculatedHalfwayCoordinates = [mapVC getHalfwayCoordinates:allLocations numberOfLocations:(int) [allLocations count]];
    
    XCTAssertTrue(fabs(expectedHalfwayCoordinates.longitude - calculatedHalfwayCoordinates.longitude) < kDeltaValue
                  && fabs(expectedHalfwayCoordinates.latitude - calculatedHalfwayCoordinates.latitude) < kDeltaValue);
}

- (void) testGetHalfwayCoordinatesForOneHundredPositiveLocations {
    NSMutableArray *allLocations = [NSMutableArray array];
    
    for(int aLocation = 0; aLocation < 100; aLocation++) {
        [allLocations addObject:[[CLLocation alloc] initWithLatitude:aLocation longitude:aLocation]];
    }
    
    CLLocationCoordinate2D expectedHalfwayCoordinates = CLLocationCoordinate2DMake(49.5, 49.5);
    CLLocationCoordinate2D calculatedHalfwayCoordinates = [mapVC getHalfwayCoordinates:allLocations numberOfLocations:(int) [allLocations count]];
    
    XCTAssertTrue(fabs(expectedHalfwayCoordinates.longitude - calculatedHalfwayCoordinates.longitude) < kDeltaValue
                  && fabs(expectedHalfwayCoordinates.latitude - calculatedHalfwayCoordinates.latitude) < kDeltaValue);
}

- (void) testGetHalfwayCoordinatesForOneHundredNegativeLocations {
    NSMutableArray *allLocations = [NSMutableArray array];
    
    for(int aLocation = -100; aLocation < 0; aLocation++) {
        [allLocations addObject:[[CLLocation alloc] initWithLatitude:aLocation longitude:aLocation]];
    }
    
    CLLocationCoordinate2D expectedHalfwayCoordinates = CLLocationCoordinate2DMake(-50.5, -50.5);
    CLLocationCoordinate2D calculatedHalfwayCoordinates = [mapVC getHalfwayCoordinates:allLocations numberOfLocations:(int) [allLocations count]];
    
    XCTAssertTrue(fabs(expectedHalfwayCoordinates.longitude - calculatedHalfwayCoordinates.longitude) < kDeltaValue
                  && fabs(expectedHalfwayCoordinates.latitude - calculatedHalfwayCoordinates.latitude) < kDeltaValue);
}


@end
