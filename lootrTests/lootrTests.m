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

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(void)testSingletonBehaviour{
    RKObjectManager* rkom = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:8081"]];
    XCTAssertEqualObjects([RKObjectManager sharedManager], rkom, @"the same");
    RKObjectManager* rkom2 = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:8082"]];
    XCTAssertEqualObjects([RKObjectManager sharedManager], rkom2, @"the same again");
}


- (void)testExample
{
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"done");
    XCTAssertTrue(true, @"test always true");
    
}
@end
