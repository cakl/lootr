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
@property (nonatomic, strong) id<ServerCaller> serverCaller;
@end

@implementation ServerCallerTests
static NSString* const apiUrlTest = @"http://salty-shelf-8389.herokuapp.com";

- (void)setUp
{
    [super setUp];
    [RKTestFactory setBaseURL:[NSURL URLWithString:apiUrlTest]];
    RKObjectManager* objectManager = [RKTestFactory objectManager];
    [RKObjectManagerHelper configureRKObjectManagerWithRequestRescriptors:objectManager];
    self.serverCaller = [[RestKitServerCaller alloc] initWithObjectManager:objectManager];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    self.serverCaller = nil;
    [super tearDown];
}

- (void)testServerCallGetLootsByDistanceOnSuccess
{
    //given
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.serverCaller getLootsAtLatitude:[NSNumber numberWithFloat:3.14] andLongitude:[NSNumber numberWithFloat:3.14] inDistance:[NSNumber numberWithInt:100] onSuccess:^(NSArray *loots) {
    //then
        XCTAssertEqual([loots count], 6, @"6 Loots were excpeted to load");
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testServerCallGetLootByIdentifier
{
    //given
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.serverCaller getLootByIdentifier:[NSNumber numberWithInt:1] onSuccess:^(Loot *loot) {
        //then
        NSLog(@"%@", loot);
        XCTAssertNotNil(loot, @"loaded loot is nil");
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testServerCallGetLootByCount
{
    //given
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.serverCaller getLootsAtLatitude:[NSNumber numberWithInt:6] andLongitude:[NSNumber numberWithFloat:3.14] withLimitedCount:[NSNumber numberWithInt:100] onSuccess:^(NSArray *loots) {
        XCTAssertEqual([loots count], 6, @"6 Loots were excpeted to load");
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testServerCallPostLoot
{
    //given
    Loot* aLoot = [Loot new];
    aLoot.identifier = [NSNumber numberWithInt:42];
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.serverCaller postLoot:aLoot onSuccess:^(Loot *loot) {
        XCTAssertNotNil(loot, @"loaded loot is nil");
        NSLog(@"%@", loot);
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        NSLog(@"%@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testServerCallPostUser
{
    //given
    User* user = [User new];
    user.userName = @"Mario";
    user.passWord = @"42";
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.serverCaller postUser:user onSuccess:^(User *user) {
        XCTAssertNotNil(user, @"loaded loot is nil");
        NSLog(@"%@", user);
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        NSLog(@"%@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testServerCallPostReport
{
    //given
    Report* report = [Report new];
    report.purpose = @"Diese Loot entspricht nicht meinem Gusto!";
    Loot* loot = [Loot new];
    loot.identifier = [NSNumber numberWithInt:42];
    loot.title = @"testloot";
    User* user = [User new];
    user.email = @"test@test.com";
    user.passWord = nil;
    report.loot = loot;
    report.creator = user;
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.serverCaller postReport:report onSuccess:^(Report *report) {
        XCTAssertNotNil(report, @"loaded report is nil");
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

- (void)testServerCallPostContent
{
    //given
    Content* content = [Content new];
    content.created = [NSDate date];
    Loot* loot = [Loot new];
    loot.identifier = [NSNumber numberWithInt:42];
    User* creator = [User new];
    creator.userName = @"Mario";
    
    UIImage* image = [UIImage imageNamed:@"ExampleImage"];
    
    //when
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.serverCaller postContent:content onLoot:loot withImage:image onSuccess:^(Content *content) {
        XCTAssertNotNil(content, @"loaded report is nil");
        dispatch_semaphore_signal(semaphore);
    } onFailure:^(NSError *error) {
        XCTFail(@"Failure returned");
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}


@end
