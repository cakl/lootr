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
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [RKTestFactory tearDown];
    [super tearDown];
}

- (void)testRegionWillChangeAnimated
{
    //given
    MKMapViewMock* mapView = [MKMapViewMock new];
    mapView.mockCenterCoordinate = CLLocationCoordinate2DMake(47.22732, 8.8189);
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
    [verify(serverCaller) getLootsAtLatitude:[latitudeArgument capture]  andLongitude:[longitudeArgument capture] inDistance:[distanceArgument capture] onSuccess:[successBlockArgument capture] onFailure:[failureBlockArgument capture]];
    NSNumber* latitude = [latitudeArgument value];
    NSNumber* longitude = [latitudeArgument value];
    success successBlock = [successBlockArgument value];
    assertThat(latitude, closeTo(47.22732, 0.1));
    assertThat(longitude, closeTo(47.22732, 0.1));
    Loot* l = [Loot new];
    l.identifier = [NSNumber numberWithInt:42];
    l.coord = [Coordinate new];
    l.coord.latitude = [NSNumber numberWithDouble:47.22732];
    l.coord.longitude = [NSNumber numberWithDouble:8.8189];
    successBlock(@[l]);
    assertThatUnsignedInt([[mapView annotations] count], equalToUnsignedInt(1));
}

@end
