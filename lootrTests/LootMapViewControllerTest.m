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
@property (nonatomic, strong) Loot *exampleLootOne, *exampleLootTwo, *exampleLootThree;
@property (nonatomic, strong) MKTArgumentCaptor *latitudeArgument, *longitudeArgument, *distanceArgument, *successBlockArgument, *failureBlockArgument;
@end

typedef void (^success)(NSArray* a);

@implementation LootMapViewControllerTest
static NSString* const apiUrlTest = @"http://salty-shelf-8389.herokuapp.com/";

- (void)setUp
{
    [super setUp];
    [RKTestFactory setBaseURL:[NSURL URLWithString:apiUrlTest]];
    [RKTestFactory objectManager];
    self.exampleLootOne = [Loot new];
    self.exampleLootOne.identifier = [NSNumber numberWithInt:42];
    self.exampleLootOne.coord = [Coordinate new];
    self.exampleLootOne.coord.latitude = [NSNumber numberWithDouble:47.22732];
    self.exampleLootOne.coord.longitude = [NSNumber numberWithDouble:8.8189];
    self.exampleLootTwo = [Loot new];
    self.exampleLootTwo.identifier = [NSNumber numberWithInt:43];
    self.exampleLootTwo.coord = [Coordinate new];
    self.exampleLootTwo.coord.latitude = [NSNumber numberWithDouble:42.22732];
    self.exampleLootTwo.coord.longitude = [NSNumber numberWithDouble:7.8189];
    self.exampleLootThree = [Loot new];
    self.exampleLootThree.identifier = [NSNumber numberWithInt:44];
    self.exampleLootThree.coord = [Coordinate new];
    self.exampleLootThree.coord.latitude = [NSNumber numberWithDouble:41.22732];
    self.exampleLootThree.coord.longitude = [NSNumber numberWithDouble:4.8189];
    self.latitudeArgument = [MKTArgumentCaptor new];
    self.longitudeArgument = [MKTArgumentCaptor new];
    self.distanceArgument = [MKTArgumentCaptor new];
    self.successBlockArgument = [MKTArgumentCaptor new];
    self.failureBlockArgument = [MKTArgumentCaptor new];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
    self.exampleLootOne = nil;
    self.exampleLootTwo = nil;
    self.exampleLootThree = nil;
    self.latitudeArgument = nil;
    self.longitudeArgument = nil;
    self.distanceArgument = nil;
    self.successBlockArgument = nil;
    self.failureBlockArgument = nil;
    [super tearDown];
}

- (void)testViewDidLoad
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(47.22732, 8.8189);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    //when
    [lootMapViewController viewDidLoad];
    //then
    
    [verify(serverCaller) getLootsAtLatitude:[self.latitudeArgument capture]  andLongitude:[self.longitudeArgument capture] inDistance:[self.distanceArgument capture] onSuccess:[self.successBlockArgument capture] onFailure:[self.failureBlockArgument capture]];
    NSNumber* latitude = [self.latitudeArgument value];
    NSNumber* longitude = [self.longitudeArgument value];
    success successBlock = [self.successBlockArgument value];
    assertThat(latitude, closeTo(centerCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(centerCoordinate.longitude, 0.1));
    successBlock(@[self.exampleLootOne, self.exampleLootTwo]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(2));
}

- (void)testRegionWillChangeAnimatedWithAddingTwoLoots
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.22732, 3.8189);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    //when
    [lootMapViewController viewDidLoad];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    
    [verifyCount(serverCaller, times(2)) getLootsAtLatitude:[self.latitudeArgument capture]  andLongitude:[self.longitudeArgument capture] inDistance:[self.distanceArgument capture] onSuccess:[self.successBlockArgument capture] onFailure:[self.failureBlockArgument capture]];
    NSNumber* latitude = [self.latitudeArgument value];
    NSNumber* longitude = [self.longitudeArgument value];
    success successBlock = [self.successBlockArgument value];
    assertThat(latitude, closeTo(centerCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(centerCoordinate.longitude, 0.1));
    successBlock(@[self.exampleLootOne, self.exampleLootTwo]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(2));
}

- (void)testRegionWillChangeAnimatedTwoTimesWithAddingDifferentLoots
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(47.22732, 8.8189);
    CLLocationCoordinate2D secondCenterCoordinate = CLLocationCoordinate2DMake(48.22732, 9.8189);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    //when
    [lootMapViewController viewDidLoad];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    [verify(serverCaller) getLootsAtLatitude:[self.latitudeArgument capture]  andLongitude:[self.longitudeArgument capture] inDistance:[self.distanceArgument capture] onSuccess:[self.successBlockArgument capture] onFailure:[self.failureBlockArgument capture]];
    NSNumber* latitude = [self.latitudeArgument value];
    NSNumber* longitude = [self.longitudeArgument value];
    success successBlock = [self.successBlockArgument value];
    assertThat(latitude, closeTo(centerCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(centerCoordinate.longitude, 0.1));
    successBlock(@[self.exampleLootOne, self.exampleLootTwo]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(2));
    
    //when
    mapView.mockCenterCoordinate = secondCenterCoordinate;
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    [verifyCount(serverCaller, times(2)) getLootsAtLatitude:[self.latitudeArgument capture]  andLongitude:[self.longitudeArgument capture] inDistance:[self.distanceArgument capture] onSuccess:[self.successBlockArgument capture] onFailure:[self.failureBlockArgument capture]];
    latitude = [self.latitudeArgument value];
    longitude = [self.longitudeArgument value];
    assertThat(latitude, closeTo(secondCenterCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(secondCenterCoordinate.longitude, 0.1));
    successBlock(@[self.exampleLootThree]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(3));
}

- (void)testRegionWillChangeAnimatedTwoTimesWithAddingSameLoots
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(47.22732, 8.8189);
    CLLocationCoordinate2D secondCenterCoordinate = CLLocationCoordinate2DMake(48.22732, 9.8189);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    //when
    [lootMapViewController viewDidLoad];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    [verify(serverCaller) getLootsAtLatitude:[self.latitudeArgument capture]  andLongitude:[self.longitudeArgument capture] inDistance:[self.distanceArgument capture] onSuccess:[self.successBlockArgument capture] onFailure:[self.failureBlockArgument capture]];
    NSNumber* latitude = [self.latitudeArgument value];
    NSNumber* longitude = [self.longitudeArgument value];
    success successBlock = [self.successBlockArgument value];
    assertThat(latitude, closeTo(centerCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(centerCoordinate.longitude, 0.1));
    successBlock(@[self.exampleLootOne, self.exampleLootTwo]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(2));
    
    //when
    mapView.mockCenterCoordinate = secondCenterCoordinate;
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    [verifyCount(serverCaller, times(2)) getLootsAtLatitude:[self.latitudeArgument capture]  andLongitude:[self.longitudeArgument capture] inDistance:[self.distanceArgument capture] onSuccess:[self.successBlockArgument capture] onFailure:[self.failureBlockArgument capture]];
    latitude = [self.latitudeArgument value];
    longitude = [self.longitudeArgument value];
    assertThat(latitude, closeTo(secondCenterCoordinate.latitude, 0.1));
    assertThat(longitude, closeTo(secondCenterCoordinate.longitude, 0.1));
    successBlock(@[self.exampleLootOne, self.exampleLootTwo]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(2));
}

- (void)testRegionWillChangeAnimatedWithToSmallScrollUpdateDistance
{
    //given
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(47.22732, 8.8189);
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = centerCoordinate;
    id <ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    LootMapViewController* lootMapViewController = [[LootMapViewController alloc] initWithServerCaller:serverCaller];
    lootMapViewController.mapView = mapView;
    //when
    [lootMapViewController viewDidLoad];
    [lootMapViewController mapView:mapView regionWillChangeAnimated:(NO)];
    //then
    [verify(serverCaller) getLootsAtLatitude:[self.latitudeArgument capture]  andLongitude:[self.longitudeArgument capture] inDistance:[self.distanceArgument capture] onSuccess:[self.successBlockArgument capture] onFailure:[self.failureBlockArgument capture]];
}

@end
