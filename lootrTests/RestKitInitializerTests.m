//
//  MappingTests.m
//  lootrapp
//
//  Created by Sebastian Bock on 17.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "RESTKitInitializer_Internal.h"
#import "RKResponseDescriptorWrapper.h"
#import "Loot.h"

#define API_URL_TEST @"http://localhost:8081"
#define BUNDLE_IDENTIFIER @"ch.hsr.lootrTests"

@interface RestKitInitializerTests : XCTestCase
@property (nonatomic, strong) RESTKitInitializer* restKitInit;
@end

@implementation RestKitInitializerTests

- (void)setUp
{
    [super setUp];
    //self.restKitInit = [[RESTKitInitializer alloc] initWithApiUrl:API_URL_TEST];
    NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:BUNDLE_IDENTIFIER];
    [RKTestFixture setFixtureBundle:testTargetBundle];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testSingleton{
    RKObjectManager* rkom = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:API_URL_TEST]];
    XCTAssertEqualObjects([RKObjectManager sharedManager], rkom, @"the same");
}

/*
-(void)testInitWithApiUrl{
    XCTAssertEqualObjects([[RKObjectManager sharedManager] baseURL], [NSURL URLWithString:API_URL_TEST], @"API URL not set on Manager");
}
/*
-(void)testInitWithApiUrlJson{
    XCTAssertEqualObjects([[RKObjectManager sharedManager] requestSerializationMIMEType], RKMIMETypeJSON, @"JSON Format not set");
}

- (void)testLootDistanceResponseDescriptor
{
    NSString* pathPattern = @"/lootrserver/api/loots/lat/47.123/long/9.8684/distance/123";
    
    RKResponseDescriptor *responseDescriptor = self.restKitInit.lootsRD;
    
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL_TEST,pathPattern]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[URL absoluteURL]];
	RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
	[requestOperation start];
	[requestOperation waitUntilFinished];
	XCTAssertTrue(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
	XCTAssertEqual([requestOperation.mappingResult count], (NSUInteger)4, @"Expected to load four loots");
}


- (void)testLootSingleMappingd
{
    Loot* loot = [Loot new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"lootSingle.json"];
    id loots = [parsedJSON objectForKey:@"loots"];
    
    RKMappingTest *test = [RKMappingTest testForMapping:self.restKitInit.lootsRD.mapping sourceObject:[loots firstObject] destinationObject:loot];
    
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

- (void)testLootSingleCreatorMapping
{
    User* user = [User new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"lootSingle.json"];
    id loots = [parsedJSON objectForKey:@"loots"];
    
    RKMappingTest *test = [RKMappingTest testForMapping:self.restKitInit.userMapping sourceObject:[loots firstObject] destinationObject:user];
    test.rootKeyPath = @"creator";
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"username" destinationKeyPath:@"userName"]];
    XCTAssertTrue([test evaluate], @"user Mapping failed");
}

- (void)testLootSingleCoordinateMapping
{
    Coordinate* coordinate = [Coordinate new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"lootSingle.json"];
    id loots = [parsedJSON objectForKey:@"loots"];
    
    RKMappingTest *test = [RKMappingTest testForMapping:self.restKitInit.coordinateMapping sourceObject:[loots firstObject] destinationObject:coordinate];
    test.rootKeyPath = @"coordinate";
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"latitude" destinationKeyPath:@"latitude"]];
    XCTAssertTrue([test evaluate], @"latitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"longitude" destinationKeyPath:@"longitude"]];
    XCTAssertTrue([test evaluate], @"longitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"location" destinationKeyPath:@"location"]];
    XCTAssertTrue([test evaluate], @"location Mapping failed");
}
*/

@end
