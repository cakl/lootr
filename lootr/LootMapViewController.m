//
//  LootViewViewController.m
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootMapViewController.h"

#import "Loot+Annotation.h"


@interface LootMapViewController ()
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D lastLocationCoordinate;
@property (nonatomic, strong) id <ServerCaller> serverCaller;
@end

@implementation LootMapViewController
static const CLLocationDistance scrollUpdateDistance = 200.0;

-(id <ServerCaller>)serverCaller{
    if (_serverCaller == nil)
    {
        _serverCaller = [[RestKitServerCaller alloc] initWithObjectManager:[RKObjectManager sharedManager]];
    }
    return _serverCaller;
}

- (instancetype)initWithServerCaller:(id <ServerCaller>)serverCaller
{
    self = [super init];
    if (self) {
        _serverCaller = serverCaller;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"MapTabIconActive"];
}

- (void)zoomIntoUserLocation
{
    MKUserLocation* aUserLocation = self.mapView.userLocation;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
    self.lastLocationCoordinate = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
}

-(void)viewWillAppear:(BOOL)animated
{
    [self zoomIntoUserLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    NSLog(@"regionDidChangeAnimated");
    MKCoordinateRegion mapRegion;
    // set the center of the map region to the now updated map view center
    mapRegion.center = mapView.centerCoordinate;
    
    mapRegion.span.latitudeDelta = 0.3; // you likely don't need these... just kinda hacked this out
    mapRegion.span.longitudeDelta = 0.3;
    
    // get the lat & lng of the map region
    double lat = mapRegion.center.latitude;
    double lng = mapRegion.center.longitude;
    
    CLLocation *before = [[CLLocation alloc] initWithLatitude:self.lastLocationCoordinate.latitude longitude:self.lastLocationCoordinate.longitude];
    CLLocation *now = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    CLLocationDistance distance = ([before distanceFromLocation:now]);
    
    NSLog(@"Scrolled distance: %@", [NSString stringWithFormat:@"%.02f", distance]);
    
    if( distance > scrollUpdateDistance )
    {
        NSLog(@"Center Latitude: %f Longitude: %f", [self.mapView centerCoordinate].latitude, [self.mapView centerCoordinate].longitude);
        [self loadLoots];
    }
    self.lastLocationCoordinate = CLLocationCoordinate2DMake(mapRegion.center.latitude, mapRegion.center.longitude);
}

- (void)loadLoots {
    [self.serverCaller getLootsAtLatitude:[NSNumber numberWithDouble:[self.mapView centerCoordinate].latitude] andLongitude:[NSNumber numberWithDouble:[self.mapView centerCoordinate].longitude] inDistance:[NSNumber numberWithInt:100] onSuccess:^(NSArray *loots) {
        NSMutableArray* newLoots = [NSMutableArray arrayWithArray:loots];
        [newLoots removeObjectsInArray:[self.mapView annotations]];
        [self.mapView addAnnotations:newLoots];
        NSLog(@"%d", [[self.mapView annotations] count]);
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
