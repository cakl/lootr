//
//  lootrTests.m
//  lootrTests
//
//  Created by Sebastian Bock on 17.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface lootrTests : XCTestCase

@end

@implementation lootrTests

-(void)testTakesThreeSeconds {
    [NSThread sleepForTimeInterval:3.0];
    XCTAssertTrue(true, @"test always true, used to fix failure with to fast tests");
}

@end
