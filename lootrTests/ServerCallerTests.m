//
//  ServerCallerTests.m
//  lootr
//
//  Created by Sebastian Bock on 29.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "RKObjectManagerHelper.h"
#import "ServerCaller.h"

@interface ServerCallerTests : XCTestCase

@end

@implementation ServerCallerTests
static NSString* const apiUrlTest = @"http://localhost:8081";

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [RKTestFactory tearDown];
    [super tearDown];
}

- (void)testServerCallLootsByDistance
{
    //given
    [RKTestFactory setBaseURL:[NSURL URLWithString:apiUrlTest]];
    RKObjectManager* objectManager = [RKTestFactory objectManager];
    [RKObjectManagerHelper configureRKObjectManagerWithRequestRescriptors:objectManager];
    ServerCaller* serverCaller = [[ServerCaller alloc] initWithObjectManager:objectManager];
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [serverCaller getLootsAtLatitude:[NSNumber numberWithFloat:3.14] andLongitude:[NSNumber numberWithFloat:3.14] inDistance:[NSNumber numberWithInt:100] onSuccess:^(NSArray *loots) {
        XCTAssertEqual([loots count], 4, @"4 Loots were excpeted to load");
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    //then
}



@end
