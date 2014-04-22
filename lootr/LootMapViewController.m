//
//  LootViewViewController.m
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootMapViewController.h"
#import "Loot+Annotation.h"
#import "LootContentViewController.h"
#import "ServerCallerFactory.h"
#import "CreateLootViewController.h"
#import "LootContentViewController.h"

@interface LootMapViewController ()
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D lastLocationCoordinate;
@property (nonatomic, strong) id <ServerCaller> serverCaller;
@property (weak, nonatomic) IBOutlet UIButton *locateUserButton;
@property (nonatomic, strong) Loot* lastSelectedLoot;
@end

@implementation LootMapViewController
static const CLLocationDistance scrollUpdateDistance = 200.0;

#pragma mark - Initialization

-(id <ServerCaller>)serverCaller{
    if (_serverCaller == nil)
    {
        _serverCaller = [ServerCallerFactory createServerCaller];
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

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"MapTabIconActive"];
    self.locateUserButton.backgroundColor = [UIColor clearColor];
    [self zoomIntoUserLocationWithCoordinateCheck];
}

-(void)viewWillAppear:(BOOL)animated
{
    // iOS 7.1 BUGFIX TABBAR: http://stackoverflow.com/questions/22327646/tab-bar-background-is-missing-on-ios-7-1-after-presenting-and-dismissing-a-view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.tabBar.translucent = NO;
        self.tabBarController.tabBar.translucent = YES;
    });
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showLoot"]){
        LootContentViewController* contentViewController = segue.destinationViewController;
        contentViewController.loot = self.lastSelectedLoot;
    }
}

#pragma mark - User Interaction

- (IBAction)buttonPressed:(id)sender {
    [self zoomIntoUserLocation];
}

- (IBAction)addLootButtonPressed:(id)sender {
    //[self performSegueWithIdentifier:@"createLoot" sender:self];
    CreateLootViewController *viewController = [[CreateLootViewController alloc] init];
    viewController.userLocation = self.mapView.userLocation;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //[self.navigationController pushViewController:viewController animated:YES];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - MapView Setup

-(void)zoomIntoUserLocationWithCoordinateCheck
{
    if(self.mapView.userLocation.coordinate.latitude < 0.01 && self.mapView.userLocation.coordinate.longitude < 0.01){
        CLLocationCoordinate2D defaultZoomInCoordinate = CLLocationCoordinate2DMake(47.22693, 8.8189);
        self.lastLocationCoordinate = defaultZoomInCoordinate;
        [self zoomIntoLocation:defaultZoomInCoordinate];
    } else {
        self.lastLocationCoordinate = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
        [self zoomIntoUserLocation];
    }
}

- (void)zoomIntoUserLocation
{
    [self zoomIntoLocation:self.mapView.userLocation.coordinate];
}

-(void)zoomIntoLocation:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = coordinate.latitude;
    location.longitude = coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
    
    [self loadLootsAtCoordinate:coordinate];
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
    NSLog(@"Span latDelta:%f, longDelta:%f", self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta);
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.centerCoordinate;
    mapRegion.span.latitudeDelta = 0.3;
    mapRegion.span.longitudeDelta = 0.3;
    double lat = mapRegion.center.latitude;
    double lng = mapRegion.center.longitude;
    CLLocation *before = [[CLLocation alloc] initWithLatitude:self.lastLocationCoordinate.latitude longitude:self.lastLocationCoordinate.longitude];
    CLLocation *now = [[CLLocation alloc] initWithLatitude:lat longitude:lng];

    CLLocationDistance distance = ([before distanceFromLocation:now]);
    NSLog(@"Scrolled distance: %@", [NSString stringWithFormat:@"%.02f", distance]);
    
    if( distance > scrollUpdateDistance )
    {
        NSLog(@"Center Latitude: %f Longitude: %f", [self.mapView centerCoordinate].latitude, [self.mapView centerCoordinate].longitude);
        [self loadLootsAtCoordinate:[self.mapView centerCoordinate]];
    }
    self.lastLocationCoordinate = CLLocationCoordinate2DMake(mapRegion.center.latitude, mapRegion.center.longitude);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"loot";
    
    if ([annotation isKindOfClass:[Loot class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"MapsMarker"];
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setTitle:annotation.title forState:UIControlStateNormal];
            [annotationView setRightCalloutAccessoryView:rightButton];
            
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        self.lastSelectedLoot = [view annotation];
        [self performSegueWithIdentifier:@"showLoot" sender:self];
    }
}

#pragma mark - Loading Data from Server

- (void)loadLootsAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.serverCaller getLootsAtLatitude:[NSNumber numberWithDouble:coordinate.latitude] andLongitude:[NSNumber numberWithDouble:coordinate.longitude] inDistance:[NSNumber numberWithInt:1000] onSuccess:^(NSArray *loots) {
        NSMutableArray* newLoots = [NSMutableArray arrayWithArray:loots];
        [newLoots removeObjectsInArray:[self.mapView annotations]];
        [self.mapView addAnnotations:newLoots];
        NSLog(@"%d", [[self.mapView annotations] count]);
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}



@end
