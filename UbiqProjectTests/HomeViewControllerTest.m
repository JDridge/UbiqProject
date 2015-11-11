#import <XCTest/XCTest.h>
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HomeViewControllerTest : XCTestCase {
    HomeViewController *homeVC;
}

@end

@implementation HomeViewControllerTest

- (void)setUp {
    homeVC = [[HomeViewController alloc] init];
    [super setUp];
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
    }];
}

-(void) testForUHValidAddress{
    XCTAssertTrue([homeVC isValidLocationEntry:@"University of Houston, Houston TX"]);
}

-(void) testForEmptyAddressInvalid{
    XCTAssertFalse([homeVC isValidLocationEntry:@""]);
}

-(void) testForHouseEmojiInvalid{
    XCTAssertFalse([homeVC isValidLocationEntry:@"🏩"]);
}


@end
