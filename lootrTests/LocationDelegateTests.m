//
//  LocationDelegateTests.m
//  lootr
//
//  Created by Sebastian Bock on 22.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreLocationDelegate.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "Errors.h"

@interface LocationDelegateTests : XCTestCase
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLGeocoder* geocoder;
@property (nonatomic, strong) CoreLocationDelegate* locationDelegate;
@end

@implementation LocationDelegateTests

- (void)setUp
{
    [super setUp];
    self.locationManager = mock([CLLocationManager class]);
    self.geocoder = mock([CLGeocoder class]);
    self.locationDelegate = [[CoreLocationDelegate alloc] initWithLocationManager:self.locationManager geocoder:self.geocoder];
}

- (void)tearDown
{
    self.locationManager = nil;
    self.geocoder = nil;
    self.locationDelegate = nil;
    [super tearDown];
}

- (void)testStartUpdatingLocationJustOnce
{
    //when
    [self.locationDelegate startUpdatingLocation];
    [self.locationDelegate startUpdatingLocation];
    //then
    [verifyCount(self.locationManager, times(1)) startUpdatingLocation];
}

- (void)testStopUpdatingLocationSuccess
{
    //when
    [self.locationDelegate stopUpdatingLocation];
    //then
    [verify(self.locationManager) stopUpdatingLocation];
}

-(void)testGetCurrentLocationFailure
{
    //given
    NSError* error = nil;
    //when
    [self.locationDelegate getCurrentLocationWithError:&error];
    //then
    XCTAssertNotNil(error, @"should throw error because of no location");
    XCTAssertTrue(error.code == locationDeterminationError, @"wrong error was thrown");
}

-(void)testGetCurrentLocationWithLocationManagerLocationSuccess
{
    //given
    CLLocation* aLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    CLLocationManager* locationManager = mock([CLLocationManager class]);
    CLGeocoder* geocoder = mock([CLGeocoder class]);
    [given([locationManager location]) willReturn:aLocation];
    CoreLocationDelegate* locationDelegate = [[CoreLocationDelegate alloc] initWithLocationManager:locationManager geocoder:geocoder];
    NSError* error = nil;
    //when
    CLLocation* returnedLocation = [locationDelegate getCurrentLocationWithError:&error];
    //then
    XCTAssertEqualObjects(returnedLocation, aLocation, @"should be the same locations");
}


@end
