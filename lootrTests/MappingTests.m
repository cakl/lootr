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

#define API_URL @"http://152.96.56.70:8080/lootrserver/"
#define BUNDLE_IDENTIFIER @"ch.hsr.lootrTests"

@interface MappingTests : XCTestCase
@property (nonatomic, strong) RESTKitInitializer* restKitInit;
@end

@implementation MappingTests

- (void)setUp
{
    [super setUp];
    self.restKitInit = [RESTKitInitializer new];
    NSBundle *testTargetBundle = [NSBundle bundleWithIdentifier:BUNDLE_IDENTIFIER];
    [RKTestFixture setFixtureBundle:testTargetBundle];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLootResponseDescriptor
{
    
    NSString* pathPattern = @"webapi/loots/X/3.14/Y/3.14";
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptorWrapper getPathPatternCorrectedRKResponseDescriptorWithRKResponseDescriptor:self.restKitInit.lootsRD];
    
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_URL,pathPattern]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[URL absoluteURL]];
	RKObjectRequestOperation *requestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    
	[requestOperation start];
	[requestOperation waitUntilFinished];
	XCTAssertTrue(requestOperation.HTTPRequestOperation.response.statusCode == 200, @"Expected 200 response");
	XCTAssertEqual([requestOperation.mappingResult count], (NSUInteger)1, @"Expected to load one loot");
}


- (void)testLootMappingIdentifier
{
    Loot* loot = [Loot new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"loots.json"];
    
    RKMappingTest *test = [RKMappingTest testForMapping:self.restKitInit.lootsRD.mapping sourceObject:parsedJSON destinationObject:loot];
    
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"id" destinationKeyPath:@"identifier"]];
    XCTAssertTrue([test evaluate], @"id Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"accuracy" destinationKeyPath:@"accuracy"]];
    XCTAssertTrue([test evaluate], @"accuracy Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"dateCreated" destinationKeyPath:@"created"]];
    XCTAssertTrue([test evaluate], @"dateCreated Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"description" destinationKeyPath:@"description"]];
    XCTAssertTrue([test evaluate], @"description Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"latitude" destinationKeyPath:@"latitude"]];
    XCTAssertTrue([test evaluate], @"latitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"longitude" destinationKeyPath:@"longitude"]];
    XCTAssertTrue([test evaluate], @"longitude Mapping failed");
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title" destinationKeyPath:@"title"]];
    XCTAssertTrue([test evaluate], @"title Mapping failed");
}

- (void)testLootMappingAccuracy
{
    User* u = [User new];
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"loots.json"];
    
    RKMappingTest *test = [RKMappingTest testForMapping:self.restKitInit.lootsRD.mapping sourceObject:parsedJSON destinationObject:u];
    test.rootKeyPath = @"creator";
    
    [test addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"username" destinationKeyPath:@"userName"]];
    XCTAssertTrue([test evaluate], @"username Mapping failed");
    NSLog(@"%@", u);
}
@end
