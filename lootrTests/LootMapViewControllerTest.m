//
//  LootMapViewControllerTest.m
//  lootr
//
//  Created by Sebastian Bock on 06.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MKMapViewMock.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "LootMapViewController.h"
#import "Loot.h"

@interface LootMapViewControllerTest : XCTestCase

@end

typedef void (^success)(NSArray* a);

@implementation LootMapViewControllerTest
static NSString* const apiUrlTest = @"http://localhost:8081";

- (void)setUp
{
    [super setUp];
    [RKTestFactory setBaseURL:[NSURL URLWithString:apiUrlTest]];
    [RKTestFactory objectManager];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    [super tearDown];
}

- (void)testRegionWillChangeAnimatedWithAddingTwoLoots
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(47.22732, 8.8189);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    Loot* lootOne = [Loot new];
    lootOne.identifier = [NSNumber numberWithInt:42];
    lootOne.coord = [Coordinate new];
    lootOne.coord.latitude = [NSNumber numberWithDouble:47.22732];
    lootOne.coord.longitude = [NSNumber numberWithDouble:8.8189];
    Loot* lootTwo = [Loot new];
    lootTwo.identifier = [NSNumber numberWithInt:43];
    lootTwo.coord = [Coordinate new];
    lootTwo.coord.latitude = [NSNumber numberWithDouble:42.22732];
    lootTwo.coord.longitude = [NSNumber numberWithDouble:7.8189];
    //when
    [lootMapViewController viewDidLoad];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    MKTArgumentCaptor *latitudeArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *longitudeArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *distanceArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *successBlockArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *failureBlockArgument = [[MKTArgumentCaptor alloc] init];
    [verify(serverCaller) getLootsAtLatitude:[latitudeArgument capture]  andLongitude:[longitudeArgument capture] inDistance:[distanceArgument capture] onSuccess:[successBlockArgument capture] onFailure:[failureBlockArgument capture]];
    NSNumber* latitude = [latitudeArgument value];
    NSNumber* longitude = [longitudeArgument value];
    success successBlock = [successBlockArgument value];
    assertThat(latitude, closeTo(centerCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(centerCoordinate.longitude, 0.1));
    successBlock(@[lootOne, lootTwo]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(2));
}

- (void)testRegionWillChangeAnimatedTwoTimesWithAddingDifferentLoots
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(47.22732, 8.8189);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    Loot* lootOne = [Loot new];
    lootOne.identifier = [NSNumber numberWithInt:42];
    lootOne.coord = [Coordinate new];
    lootOne.coord.latitude = [NSNumber numberWithDouble:47.22732];
    lootOne.coord.longitude = [NSNumber numberWithDouble:8.8189];
    Loot* lootTwo = [Loot new];
    lootTwo.identifier = [NSNumber numberWithInt:43];
    lootTwo.coord = [Coordinate new];
    lootTwo.coord.latitude = [NSNumber numberWithDouble:42.22732];
    lootTwo.coord.longitude = [NSNumber numberWithDouble:7.8189];
    //when
    [lootMapViewController viewDidLoad];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    MKTArgumentCaptor *latitudeArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *longitudeArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *distanceArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *successBlockArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *failureBlockArgument = [[MKTArgumentCaptor alloc] init];
    [verify(serverCaller) getLootsAtLatitude:[latitudeArgument capture]  andLongitude:[longitudeArgument capture] inDistance:[distanceArgument capture] onSuccess:[successBlockArgument capture] onFailure:[failureBlockArgument capture]];
    NSNumber* latitude = [latitudeArgument value];
    NSNumber* longitude = [longitudeArgument value];
    success successBlock = [successBlockArgument value];
    assertThat(latitude, closeTo(centerCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(centerCoordinate.longitude, 0.1));
    successBlock(@[lootOne, lootTwo]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(2));
    
    CLLocationCoordinate2D secondCenterCoordinate = CLLocationCoordinate2DMake(48.22732, 9.8189);
    mapView.mockCenterCoordinate = secondCenterCoordinate;
    Loot* lootThree = [Loot new];
    lootOne.identifier = [NSNumber numberWithInt:44];
    lootOne.coord = [Coordinate new];
    lootOne.coord.latitude = [NSNumber numberWithDouble:41.22732];
    lootOne.coord.longitude = [NSNumber numberWithDouble:4.8189];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    latitudeArgument = [[MKTArgumentCaptor alloc] init];
    longitudeArgument = [[MKTArgumentCaptor alloc] init];
    distanceArgument = [[MKTArgumentCaptor alloc] init];
    successBlockArgument = [[MKTArgumentCaptor alloc] init];
    [verifyCount(serverCaller, times(2)) getLootsAtLatitude:[latitudeArgument capture]  andLongitude:[longitudeArgument capture] inDistance:[distanceArgument capture] onSuccess:[successBlockArgument capture] onFailure:[failureBlockArgument capture]];
    latitude = [latitudeArgument value];
    longitude = [longitudeArgument value];
    assertThat(latitude, closeTo(secondCenterCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(secondCenterCoordinate.longitude, 0.1));
    successBlock(@[lootThree]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(3));
}

- (void)testRegionWillChangeAnimatedWithToSmallScrollUpdateDistance
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(0.00, 0.000);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    //when
    [lootMapViewController viewDidLoad];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    MKTArgumentCaptor *latitudeArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *longitudeArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *distanceArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *successBlockArgument = [[MKTArgumentCaptor alloc] init];
    MKTArgumentCaptor *failureBlockArgument = [[MKTArgumentCaptor alloc] init];
    [verifyCount(serverCaller, never()) getLootsAtLatitude:[latitudeArgument capture]  andLongitude:[longitudeArgument capture] inDistance:[distanceArgument capture] onSuccess:[successBlockArgument capture] onFailure:[failureBlockArgument capture]];
}

@end
