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
#import "RestKitServerCaller.h"
#import "ServerCaller.h"
#import "Loot.h"

@interface ServerCallerTests : XCTestCase

@end

@implementation ServerCallerTests
static NSString* const apiUrlTest = @"http://localhost:8081";

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    [super tearDown];
}

- (void)testServerCallLootsByDistanceOnSuccess
{
    //given
    [RKTestFactory setBaseURL:[NSURL URLWithString:apiUrlTest]];
    RKObjectManager* objectManager = [RKTestFactory objectManager];
    [RKObjectManagerHelper configureRKObjectManagerWithRequestRescriptors:objectManager];
    id <ServerCaller> serverCaller = [[RestKitServerCaller alloc] initWithObjectManager:objectManager];
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [serverCaller getLootsAtLatitude:[NSNumber numberWithFloat:3.14] andLongitude:[NSNumber numberWithFloat:3.14] inDistance:[NSNumber numberWithInt:100] onSuccess:^(NSArray *loots) {
    //then
        XCTAssertEqual([loots count], 6, @"6 Loots were excpeted to load");
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}







@end
