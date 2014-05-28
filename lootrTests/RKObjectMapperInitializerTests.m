//
//  RKObjectMapperInitializerTests.m
//  lootr
//
//  Created by Sebastian Bock on 26.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "RKObjectManagerHelper.h"
#import "Loot.h"
#import "Report.h"
#import "TestConstants.h"

@interface RKObjectMapperInitializerTests : XCTestCase
-(RKResponseDescriptor*)getResponseDescriptorByPathPattern:(NSString*)pathPattern onObjectManager:(RKObjectManager*)objectManager;

@end

@implementation RKObjectMapperInitializerTests

static NSString *const bundleIdentifier = @"ch.hsr.lootrTests";
static NSString *const lootsKeyPath = @"loots";
static NSString *const contentsKeyPath = @"contents";
static NSString *const usersKeyPath = @"users";
static NSString *const reportsKeyPath = @"reports";
static NSString *const lootsListJsonFileName = @"lootList.json";
static NSString *const lootsSingleJsonFileName = @"lootSingle.json";
static NSString *const usersSingleFileName = @"usersSingle.json";
static NSString *const reportSingleFileName = @"reportsSingle.json";

-(void)setUp {
    [super setUp];
    NSBundle* testTargetBundle = [NSBundle bundleWithIdentifier:bundleIdentifier];
    [RKTestFixture setFixtureBundle:testTargetBundle];
    [RKTestFactory setBaseURL:[NSURL URLWithString:mockingServerURL]];
    RKObjectManager* objectManager = [RKTestFactory objectManager];
    [RKObjectManagerHelper configureRKObjectManagerWithRequestRescriptors:objectManager];
}

-(void)tearDown {
    [RKTestFactory tearDown];
    [super tearDown];
}

-(RKResponseDescriptor*)getResponseDescriptorByPathPattern:(NSString*)pathPattern onObjectManager:(RKObjectManager*)objectManager {
    NSUInteger idx = [[objectManager responseDescriptors] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        if([[obj pathPattern] isEqualToString:pathPattern]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if(idx == NSNotFound) {
        return nil;
    }
    return [[objectManager responseDescriptors] objectAtIndex:idx];
}

-(void)testResponseDescriptorsWithLootById {
    //given
    NSString* pathUnderTest = @"/lootrserver/api/v1/loots/3";
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/:id";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    if(responseDescriptor == nil) {
        XCTFail(@"Reponse Descriptor under Test was not found on object Manager under Test");
    } else {
        NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", mockingServerURL, pathUnderTest]];
        NSURLRequest* request = [NSURLRequest requestWithURL:[URL absoluteURL]];
        RKObjectRequestOperation* requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
        //when
        [requestOperation start];
        [requestOperation waitUntilFinished];
        //then
        XCTAssertTrue(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
        XCTAssertEqual([requestOperation.mappingResult count], (NSUInteger)1, @"Expected to load exactly one loot");
        Loot* aLoot = [[requestOperation.mappingResult array] firstObject];
        XCTAssertEqual([[aLoot contents] count], 3, @"Expected to load 3 contents on the loot");
    }
}

-(void)testResponseDescriptorsWithLootsInDistanceCall {
    //given
    NSString* pathUnderTest = @"/lootrserver/api/v1/loots/latitude/47.22693/longitude/8.8189/distance/200";
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    if(responseDescriptor == nil) {
        XCTFail(@"Reponse Descriptor under Test was not found on object Manager under Test");
    } else {
        NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", mockingServerURL, pathUnderTest]];
        NSURLRequest* request = [NSURLRequest requestWithURL:[URL absoluteURL]];
        RKObjectRequestOperation* requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
        //when
        [requestOperation start];
        [requestOperation waitUntilFinished];
        //then
        XCTAssertTrue(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
        XCTAssertEqual([requestOperation.mappingResult count], (NSUInteger)10, @"Expected to load 10 loots");
    }
}

-(void)testResponseDescriptorsWithLootsByCountCall {
    //given
    NSString* pathUnderTest = @"/lootrserver/api/v1/loots/latitude/47.22693/longitude/8.8189/count/6";
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/count/:count";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    if(responseDescriptor == nil) {
        XCTFail(@"Reponse Descriptor under Test was not found on object Manager under Test");
    } else {
        NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", mockingServerURL, pathUnderTest]];
        NSURLRequest* request = [NSURLRequest requestWithURL:[URL absoluteURL]];
        RKObjectRequestOperation* requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
        //when
        [requestOperation start];
        [requestOperation waitUntilFinished];
        //then
        XCTAssertTrue(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
        XCTAssertEqual([requestOperation.mappingResult count], (NSUInteger)10, @"Expected to load 6 loots");
    }
}

-(void)testLootsMapping {
    //given
    Loot* loot = [Loot new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:lootsListJsonFileName];
    id loots = [parsedJSON objectForKey:lootsKeyPath];

    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    if(responseDescriptor == nil) {
        XCTFail(@"Reponse Descriptor under Test was not found on Object Manager under Test");
    } else {
        //when
        RKMappingTest* test = [RKMappingTest testForMapping:responseDescriptor.mapping sourceObject:[loots firstObject] destinationObject:loot];
        //then
        [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"id" destinationKeyPath:@"identifier"]];
        XCTAssertTrue([test evaluate], @"id Mapping failed");
        [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"radius" destinationKeyPath:@"radius"]];
        XCTAssertTrue([test evaluate], @"radius Mapping failed");
        [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"dateCreated" destinationKeyPath:@"created"]];
        XCTAssertTrue([test evaluate], @"dateCreated Mapping failed");
        [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"summary" destinationKeyPath:@"summary"]];
        XCTAssertTrue([test evaluate], @"summary Mapping failed");
        [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title"]];
        XCTAssertTrue([test evaluate], @"title Mapping failed");
    }
}

-(void)testNestedCreatorInLootsMapping {
    //given
    User* user = [User new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:lootsListJsonFileName];
    id loots = [parsedJSON objectForKey:lootsKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* lootsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    RKRelationshipMapping* creatorRelationshipMapping = [[lootsMapping propertyMappingsByDestinationKeyPath] objectForKey:@"creator"];
    
    RKMappingTest* test = [RKMappingTest testForMapping:[creatorRelationshipMapping mapping] sourceObject:[loots firstObject] destinationObject:user];
    test.rootKeyPath = @"creator";
    //when
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"username" destinationKeyPath:@"userName"]];
    //then
    XCTAssertTrue([test evaluate], @"user Mapping failed");
}

-(void)testNestedCoordinateInLootsMapping {
    //given
    Coordinate* coordinate = [Coordinate new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:lootsListJsonFileName];
    id loots = [parsedJSON objectForKey:lootsKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* lootsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    RKRelationshipMapping* coordinateRelationshipMapping = [[lootsMapping propertyMappingsByDestinationKeyPath] objectForKey:@"coord"];
    //when
    RKMappingTest* test = [RKMappingTest testForMapping:[coordinateRelationshipMapping mapping] sourceObject:[loots firstObject] destinationObject:coordinate];
    test.rootKeyPath = @"coordinate";
    //then
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"latitude" destinationKeyPath:@"latitude"]];
    XCTAssertTrue([test evaluate], @"latitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"longitude" destinationKeyPath:@"longitude"]];
    XCTAssertTrue([test evaluate], @"longitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"location" destinationKeyPath:@"location"]];
    XCTAssertTrue([test evaluate], @"location Mapping failed");
}

-(void)testNestedContentsInLootsMapping {
    //given
    Content* aContent = [Content new];
    NSSet* contents = [NSSet setWithObject:aContent];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:lootsSingleJsonFileName];
    id parsedLoots = [parsedJSON objectForKey:lootsKeyPath];
    id parsedContents = [[parsedLoots firstObject] objectForKey:contentsKeyPath];
    id parsedContent = [parsedContents firstObject];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/:id";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* lootsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    RKRelationshipMapping* contentsRelationshipMapping = [[lootsMapping propertyMappingsByDestinationKeyPath] objectForKey:@"contents"];
    //when
    RKMappingTest* test = [RKMappingTest testForMapping:[contentsRelationshipMapping mapping] sourceObject:parsedContent destinationObject:contents];
    //then
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"id" destinationKeyPath:@"identifier"]];
    XCTAssertTrue([test evaluate], @"identifier Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"type" destinationKeyPath:@"type"]];
    XCTAssertTrue([test evaluate], @"type Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"url" destinationKeyPath:@"url"]];
    XCTAssertTrue([test evaluate], @"url Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"thumb" destinationKeyPath:@"thumb"]];
    XCTAssertTrue([test evaluate], @"thumb Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"dateCreated" destinationKeyPath:@"created"]];
    XCTAssertTrue([test evaluate], @"dateCreated Mapping failed");
}

-(void)testUserMapping {
    //given
    User* aUser = [User new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:usersSingleFileName];
    id parsedUsers = [parsedJSON objectForKey:usersKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/users/login";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* usersMapping = (RKObjectMapping*) responseDescriptor.mapping;
    
    //when
    RKMappingTest* test = [RKMappingTest testForMapping:usersMapping sourceObject:[parsedUsers firstObject] destinationObject:aUser];
    //then
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"username" destinationKeyPath:@"userName"]];
    XCTAssertTrue([test evaluate], @"username Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"email" destinationKeyPath:@"email"]];
    XCTAssertTrue([test evaluate], @"email Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"token" destinationKeyPath:@"token"]];
    XCTAssertTrue([test evaluate], @"token Mapping failed");
}

-(void)testReportMapping {
    //given
    Report* aReport = [Report new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:reportSingleFileName];
    id parsedReports = [parsedJSON objectForKey:reportsKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/reports";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* reportsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    
    //when
    RKMappingTest* test = [RKMappingTest testForMapping:reportsMapping sourceObject:[parsedReports firstObject] destinationObject:aReport];
    //then
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"purpose" destinationKeyPath:@"purpose"]];
    XCTAssertTrue([test evaluate], @"purpose Mapping failed");
}

-(void)testNestedCreatorInReportMapping {
    //given
    User* aUser = [User new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:reportSingleFileName];
    id reports = [parsedJSON objectForKey:reportsKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/reports";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* reportsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    RKRelationshipMapping* creatorRelationshipMapping = [[reportsMapping propertyMappingsByDestinationKeyPath] objectForKey:@"creator"];
    //when
    RKMappingTest* test = [RKMappingTest testForMapping:[creatorRelationshipMapping mapping] sourceObject:[reports firstObject] destinationObject:aUser];
    test.rootKeyPath = @"creator";
    //then
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"username" destinationKeyPath:@"userName"]];
    XCTAssertTrue([test evaluate], @"username Mapping failed");
}

-(void)testNestedLootInReportMapping {
    //given
    Loot* aUser = [Loot new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:reportSingleFileName];
    id reports = [parsedJSON objectForKey:reportsKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/reports";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* reportsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    RKRelationshipMapping* lootRelationshipMapping = [[reportsMapping propertyMappingsByDestinationKeyPath] objectForKey:@"loot"];
    //when
    RKMappingTest* test = [RKMappingTest testForMapping:[lootRelationshipMapping mapping] sourceObject:[reports firstObject] destinationObject:aUser];
    test.rootKeyPath = @"loot";
    //then
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"id" destinationKeyPath:@"identifier"]];
    XCTAssertTrue([test evaluate], @"identifier Mapping failed");
}

@end
