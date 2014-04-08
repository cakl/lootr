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

@interface RKObjectMapperInitializerTests : XCTestCase
-(RKResponseDescriptor*)getResponseDescriptorByPathPattern:(NSString*)pathPattern onObjectManager:(RKObjectManager*)objectManager;
@end

@implementation RKObjectMapperInitializerTests
static NSString* const apiUrlTest = @"http://localhost:8081";
static NSString* const bundleIdentifier = @"ch.hsr.lootrTests";
static NSString* const lootsKeyPath = @"loots";
static NSString* const lootsSingleJsonFileName = @"lootList.json";

- (void)setUp
{
    [super setUp];
    NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:bundleIdentifier];
    [RKTestFixture setFixtureBundle:testTargetBundle];
    [RKTestFactory setBaseURL:[NSURL URLWithString:apiUrlTest]];
    RKObjectManager* objectManager = [RKTestFactory objectManager];
    [RKObjectManagerHelper configureRKObjectManagerWithRequestRescriptors:objectManager];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    [super tearDown];
}

-(RKResponseDescriptor*)getResponseDescriptorByPathPattern:(NSString*)pathPattern onObjectManager:(RKObjectManager*)objectManager
{
    NSUInteger idx = [[objectManager responseDescriptors] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if([[obj pathPattern] isEqualToString:pathPattern]){
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    if(idx == NSNotFound){
        return nil;
    }
    return [[objectManager responseDescriptors] objectAtIndex:idx];
}

-(void)testResponseDescriptorsWithLootsInDistanceCall
{
    //given
    NSString* pathUnderTest = @"/lootrserver/api/v1/loots/latitude/47.22693/longitude/8.8189/distance/200";
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    
    if(responseDescriptor == nil) {
        XCTFail(@"Reponse Descriptor under Test was not found on object Manager under Test");
    } else {
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",apiUrlTest,pathUnderTest]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[URL absoluteURL]];
        RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
        //when
        [requestOperation start];
        [requestOperation waitUntilFinished];
        //then
        XCTAssertTrue(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
        XCTAssertEqual([requestOperation.mappingResult count], (NSUInteger)6, @"Expected to load 6 loots");
    }
}

-(void)testLootsMapping
{
    //given
    Loot* loot = [Loot new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:lootsSingleJsonFileName];
    id loots = [parsedJSON objectForKey:lootsKeyPath];

    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    
    if(responseDescriptor == nil) {
        XCTFail(@"Reponse Descriptor under Test was not found on Object Manager under Test");
    } else {
        //when
        RKMappingTest *test = [RKMappingTest testForMapping:responseDescriptor.mapping sourceObject:[loots firstObject] destinationObject:loot];
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

-(void)testNestedCreatorInLootsMapping
{
    //given
    User* user = [User new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:lootsSingleJsonFileName];
    id loots = [parsedJSON objectForKey:lootsKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* lootsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    RKRelationshipMapping* creatorRelationshipMapping = [[lootsMapping propertyMappingsByDestinationKeyPath] objectForKey:@"creator"];
    
    RKMappingTest *test = [RKMappingTest testForMapping:[creatorRelationshipMapping mapping] sourceObject:[loots firstObject] destinationObject:user];
    test.rootKeyPath = @"creator";
    //when
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"username" destinationKeyPath:@"userName"]];
    //then
    XCTAssertTrue([test evaluate], @"user Mapping failed");
}

-(void)testNestedCoordinateInLootsMapping
{
    //given
    Coordinate* coordinate = [Coordinate new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:lootsSingleJsonFileName];
    id loots = [parsedJSON objectForKey:lootsKeyPath];
    
    NSString* pathPatternUnderTest = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    RKResponseDescriptor* responseDescriptor = [self getResponseDescriptorByPathPattern:pathPatternUnderTest onObjectManager:objectManager];
    RKObjectMapping* lootsMapping = (RKObjectMapping*) responseDescriptor.mapping;
    RKRelationshipMapping* coordinateRelationshipMapping = [[lootsMapping propertyMappingsByDestinationKeyPath] objectForKey:@"coord"];
    //when
    RKMappingTest *test = [RKMappingTest testForMapping:[coordinateRelationshipMapping mapping] sourceObject:[loots firstObject] destinationObject:coordinate];
    test.rootKeyPath = @"coordinate";
    //then
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"latitude" destinationKeyPath:@"latitude"]];
    XCTAssertTrue([test evaluate], @"latitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"longitude" destinationKeyPath:@"longitude"]];
    XCTAssertTrue([test evaluate], @"longitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"location" destinationKeyPath:@"location"]];
    XCTAssertTrue([test evaluate], @"location Mapping failed");
}

@end
