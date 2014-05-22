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

@interface LocationDelegateTests : XCTestCase

@end

@implementation LocationDelegateTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{
    
    [super tearDown];
}

- (void)testStartUpdatingLocationSuccess
{
    CLLocationManager* locationManager = mock([CLLocationManager class]);
    CLGeocoder* geocoder = mock([CLGeocoder class]);
    CoreLocationDelegate* locationDelegate = [[CoreLocationDelegate alloc] initWithLocationManager:locationManager geocoder:geocoder];
    [locationDelegate startUpdatingLocation];
    [verify(locationManager) startUpdatingLocation];
}

@end
