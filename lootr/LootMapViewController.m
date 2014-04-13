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

@interface LootMapViewController ()
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D lastLocationCoordinate;
@property (nonatomic, strong) id <ServerCaller> serverCaller;
@property (weak, nonatomic) IBOutlet UIButton *locateUserButton;
@property (nonatomic, strong) Loot* lastSelectedLoot;
@end

@implementation LootMapViewController
static const CLLocationDistance scrollUpdateDistance = 200.0;

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

- (IBAction)buttonPressed:(id)sender {
    [self zoomIntoUserLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"MapTabIconActive"];
    self.locateUserButton.backgroundColor = [UIColor clearColor];
    [self zoomIntoUserLocationWithCoordinateCheck];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

-(void)zoomIntoUserLocationWithCoordinateCheck
{
    if(self.mapView.userLocation.coordinate.latitude < 0.01 && self.mapView.userLocation.coordinate.longitude < 0.01){
        CLLocationCoordinate2D defaultZoomInCoordinate = CLLocationCoordinate2DMake(47.22693, 8.8189);
        [self zoomIntoLocation:defaultZoomInCoordinate];
    } else {
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
    self.lastLocationCoordinate = CLLocationCoordinate2DMake(self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showLoot"]){
        LootContentViewController* contentViewController = segue.destinationViewController;
        contentViewController.loot = self.lastSelectedLoot;
    }
}

@end
