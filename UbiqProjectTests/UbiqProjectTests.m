//
//  UbiqProjectTests.m
//  UbiqProjectTests
//
//  Created by Joey on 10/2/15.
//  Copyright © 2015 Joey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface UbiqProjectTests : XCTestCase

@end

@implementation UbiqProjectTests

- (void)setUp {
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
        // Put the code you want to measure the time of here.
    }];
}

-(void) testForUHValidAddress{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    XCTAssertTrue([homeVC isValidLocationEntry:@"University of Houston, Houston TX"]);
}

-(void) testForEmptyAddressInvalid{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    XCTAssertFalse([homeVC isValidLocationEntry:@""]);
}

-(void) testForHouseEmojiInvalid{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    XCTAssertFalse([homeVC isValidLocationEntry:@"🏩"]);
}

@end
