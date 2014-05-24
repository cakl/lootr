//
//  LocationServiceTests.m
//  lootr
//
//  Created by Sebastian Bock on 24.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationService.h"
#import "CoreLocationDelegateStub.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface LocationServiceTests : XCTestCase
@end

@implementation LocationServiceTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    
    [super tearDown];
}

- (void)testGetDistanceThresholdfromCurrentLocationToLootWithFiveMetersDistance
{
    //given
    CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:47.223314 longitude:8.817265];
    CoreLocationDelegateStub* locationDelegateStub = [[CoreLocationDelegateStub alloc] initWithCurrentLocation:currentLocation];
    LocationService* locationService = [[LocationService alloc] initWithLocationDelegate:locationDelegateStub];
    Coordinate* lootCordinate = [[Coordinate alloc] init];
    lootCordinate.latitude = [NSNumber numberWithDouble:47.223313];
    lootCordinate.longitude = [NSNumber numberWithDouble:8.817265];
    Loot* loot = [[Loot alloc] init];
    loot.coord = lootCordinate;

    //when
    DistanceTreshold distanceThreshold = [locationService getDistanceThresholdfromCurrentLocationToLoot:loot];
    //then
    XCTAssertTrue(distanceThreshold == DistanceTresholdFiveMeters, @"Wrong distance threshold returned");
}

- (void)testGetDistanceThresholdfromCurrentLocationToLootWithMoreThanFiveHundredMetersDistance
{
    //given
    CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:46.957896 longitude:7.435332];
    CoreLocationDelegateStub* locationDelegateStub = [[CoreLocationDelegateStub alloc] initWithCurrentLocation:currentLocation];
    LocationService* locationService = [[LocationService alloc] initWithLocationDelegate:locationDelegateStub];
    Coordinate* lootCordinate = [[Coordinate alloc] init];
    lootCordinate.latitude = [NSNumber numberWithDouble:47.223313];
    lootCordinate.longitude = [NSNumber numberWithDouble:8.817265];
    Loot* loot = [[Loot alloc] init];
    loot.coord = lootCordinate;
    
    //when
    DistanceTreshold distanceThreshold = [locationService getDistanceThresholdfromCurrentLocationToLoot:loot];
    //then
    XCTAssertTrue(distanceThreshold == DistanceTresholdMoreThanFiveHundredMeters, @"Wrong distance threshold returned");
}

- (void)testGetDistanceThresholdfromCurrentLocationToLootWithNilLootFailure
{
    //given
    CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:47.223314 longitude:8.817265];
    CoreLocationDelegateStub* locationDelegateStub = [[CoreLocationDelegateStub alloc] initWithCurrentLocation:currentLocation];
    LocationService* locationService = [[LocationService alloc] initWithLocationDelegate:locationDelegateStub];
    
    //when
    DistanceTreshold distanceThreshold = [locationService getDistanceThresholdfromCurrentLocationToLoot:nil];
    //then
    XCTAssertTrue(distanceThreshold == DistanceTresholdUndetermined, @"Wrong distance threshold returned");
}

-(void)testIsCurrentLocationInRadiusOfLootWithRadiusNearSuccess
{
    //given
    CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:47.223314 longitude:8.817265];
    CoreLocationDelegateStub* locationDelegateStub = [[CoreLocationDelegateStub alloc] initWithCurrentLocation:currentLocation];
    LocationService* locationService = [[LocationService alloc] initWithLocationDelegate:locationDelegateStub];
    Coordinate* lootCordinate = [[Coordinate alloc] init];
    lootCordinate.latitude = [NSNumber numberWithDouble:47.223313];
    lootCordinate.longitude = [NSNumber numberWithDouble:8.817265];
    Loot* loot = [[Loot alloc] init];
    loot.coord = lootCordinate;
    loot.radius = [NSNumber numberWithInt:AccuracyNear];
    
    //when
    BOOL isCurrentLocationInRadiusOfLoot = [locationService isCurrentLocationInRadiusOfLoot:loot];
    //then
    XCTAssertTrue(isCurrentLocationInRadiusOfLoot, @"Current Location should be in radius of loot");
}

-(void)testIsCurrentLocationInRadiusOfLootWithRadiusNearFailure
{
    //given
    CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:47.223314 longitude:8.817265];
    CoreLocationDelegateStub* locationDelegateStub = [[CoreLocationDelegateStub alloc] initWithCurrentLocation:currentLocation];
    LocationService* locationService = [[LocationService alloc] initWithLocationDelegate:locationDelegateStub];
    Coordinate* lootCordinate = [[Coordinate alloc] init];
    lootCordinate.latitude = [NSNumber numberWithDouble:46.957896];
    lootCordinate.longitude = [NSNumber numberWithDouble:7.435332];
    Loot* loot = [[Loot alloc] init];
    loot.coord = lootCordinate;
    loot.radius = [NSNumber numberWithInt:AccuracyNear];
    
    //when
    BOOL isCurrentLocationInRadiusOfLoot = [locationService isCurrentLocationInRadiusOfLoot:loot];
    //then
    XCTAssertFalse(isCurrentLocationInRadiusOfLoot, @"Current Location should not be in radius of loot");
}

-(void)testIsCurrentLocationInRadiusOfLootWithNoLootFailure
{
    //given
    CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:47.223314 longitude:8.817265];
    CoreLocationDelegateStub* locationDelegateStub = [[CoreLocationDelegateStub alloc] initWithCurrentLocation:currentLocation];
    LocationService* locationService = [[LocationService alloc] initWithLocationDelegate:locationDelegateStub];
    
    //when
    BOOL isCurrentLocationInRadiusOfLoot = [locationService isCurrentLocationInRadiusOfLoot:nil];
    //then
    XCTAssertFalse(isCurrentLocationInRadiusOfLoot, @"Current Location should not be in radius of nil loot");
}

@end
