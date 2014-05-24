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
    CLLocation* returnedLocation = [self.locationDelegate getCurrentLocationWithError:&error];
    //then
    XCTAssertNotNil(error, @"should throw error because of no location");
    XCTAssertTrue(error.code == locationDeterminationError, @"wrong or no error was thrown");
    XCTAssertNil(returnedLocation, @"In case of error message should return nil");
}

-(void)testGetCurrentLocationWithLocationManagerLocationSuccess
{
    //given
    CLLocation* aLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    [given([self.locationManager location]) willReturn:aLocation];
    NSError* error = nil;
    //when
    CLLocation* returnedLocation = [self.locationDelegate getCurrentLocationWithError:&error];
    //then
    XCTAssertEqualObjects(returnedLocation, aLocation, @"should be the same locations");
}

-(void)testGetCurrentLocationWithSettingLocationSuccess
{
    //given
    CLLocation* aLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    [given([self.locationManager location]) willReturn:aLocation];
    NSError* error = nil;
    //when
    [self.locationDelegate getCurrentLocationWithError:&error];
    //then
    [verify(self.locationManager) startUpdatingLocation];
}

-(void)testGetCurrentLocationWithUpdatedLocationSuccess
{
    //given
    CLLocation* aLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    CLLocation* anotherLocation = [[CLLocation alloc] initWithLatitude:47.224225 longitude:8.825461];
    [given([self.locationManager location]) willReturn:aLocation];
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[anotherLocation]];
    NSError* error = nil;
    //when
    CLLocation* returnedLocation = [self.locationDelegate getCurrentLocationWithError:&error];
    //then
    XCTAssertEqualObjects(returnedLocation, anotherLocation, @"should be the same locations");
}

-(void)testGetCurrentCityFailure
{
    //given
    NSError* error = nil;
    //when
    NSString* returnedCity = [self.locationDelegate getCurrentCityWithError:&error];
    //then
    XCTAssertNotNil(error, @"should throw error because of no location");
    XCTAssertTrue(error.code == geocodeDeterminationError, @"wrong or no error was thrown");
    XCTAssertNil(returnedCity, @"In case of error message should return nil");
}

-(void)testDidUpdateLocationTwice
{
    //given
    CLLocation* firstLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    CLLocation* secondLocation = [[CLLocation alloc] initWithLatitude:47.224225 longitude:8.825461];
    CLLocation* thirdLocation = [[CLLocation alloc] initWithLatitude:43.818433 longitude:3.292064];
    [given([self.locationManager location]) willReturn:firstLocation];
    //when
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[secondLocation]];
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[thirdLocation]];
    //then
    NSError* error = nil;
    CLLocation* returnedLocation = [self.locationDelegate getCurrentLocationWithError:&error];
    XCTAssertEqualObjects(returnedLocation, thirdLocation, @"returned location should be last updated location");
}

-(void)testGeocodeCityByLocationWithOneUpdateSuccess{
    //given
    CLLocation* firstLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    CLLocation* secondLocation = [[CLLocation alloc] initWithLatitude:47.224225 longitude:8.825461];
    [given([self.locationManager location]) willReturn:firstLocation];
    CLPlacemark* placemark = mock([CLPlacemark class]);
    NSString* givenCity = @"Rapperswil";
    [given([placemark subLocality]) willReturn:givenCity];
    MKTArgumentCaptor *locationArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *completionHandlerArgument = [[MKTArgumentCaptor alloc] init];
    NSError* cityError = nil;
    //when
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[secondLocation]];
    //then
    [verify(self.geocoder) reverseGeocodeLocation:[locationArgument capture] completionHandler:[completionHandlerArgument capture]];
    CLLocation* returnedLocation = [locationArgument value];
    CLGeocodeCompletionHandler completionHandler = [completionHandlerArgument value];
    completionHandler(@[placemark], nil);
    XCTAssertEqualObjects(returnedLocation, secondLocation, @"should return the same object");
    NSString* returnedCity = [self.locationDelegate getCurrentCityWithError:&cityError];
    XCTAssertEqualObjects(returnedCity, givenCity, @"given and returned city should be the same");
}

-(void)testGeocodeCityByLocationWithTwoUpdateSuccess{
    //given
    CLLocation* firstLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    CLLocation* secondLocation = [[CLLocation alloc] initWithLatitude:47.224225 longitude:8.825461];
    CLLocation* thirdLocation = [[CLLocation alloc] initWithLatitude:43.818433 longitude:3.292064];
    [given([self.locationManager location]) willReturn:firstLocation];
    CLPlacemark* placemark = mock([CLPlacemark class]);
    NSString* givenCity = @"Montpellier";
    [given([placemark subLocality]) willReturn:givenCity];
    MKTArgumentCaptor *locationArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *completionHandlerArgument = [[MKTArgumentCaptor alloc] init];
    NSError* cityError = nil;
    //when
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[secondLocation]];
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[thirdLocation]];
    //then
    [verifyCount(self.geocoder, times(2)) reverseGeocodeLocation:[locationArgument capture] completionHandler:[completionHandlerArgument capture]];
    CLLocation* returnedLocation = [locationArgument value];
    CLGeocodeCompletionHandler completionHandler = [completionHandlerArgument value];
    completionHandler(@[placemark], nil);
    XCTAssertEqualObjects(returnedLocation, thirdLocation, @"should return the same object");
    NSString* returnedCity = [self.locationDelegate getCurrentCityWithError:&cityError];
    XCTAssertEqualObjects(returnedCity, givenCity, @"given and returned city should be the same");
}

-(void)testGeocodeCityByLocationWithTwoUpdateAndNotEnoughUpdateDistance{
    //given
    CLLocation* firstLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    CLLocation* secondLocation = [[CLLocation alloc] initWithLatitude:47.224225 longitude:8.825461];
    CLLocation* thirdLocation = [[CLLocation alloc] initWithLatitude:47.223278 longitude:8.822565];
    [given([self.locationManager location]) willReturn:firstLocation];
    CLPlacemark* placemark = mock([CLPlacemark class]);
    NSString* givenCity = @"Rapperswil";
    [given([placemark subLocality]) willReturn:givenCity];
    MKTArgumentCaptor *locationArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *completionHandlerArgument = [[MKTArgumentCaptor alloc] init];
    //when
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[secondLocation]];
    [self.locationDelegate locationManager:self.locationManager didUpdateLocations:@[thirdLocation]];
    //then
    [verifyCount(self.geocoder, times(1)) reverseGeocodeLocation:[locationArgument capture] completionHandler:[completionHandlerArgument capture]];
}

@end
