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
#import "CreateLootViewController.h"
#import "Facade.h"
#import "ServerCallerFacadeFactory.h"
#import "ServerCaller.h"
#import "ServerCallerFactory.h"


@interface LootMapViewController ()
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D lastLocationCoordinate;
@property (nonatomic, strong) id<Facade> facade;
@property (weak, nonatomic) IBOutlet UIButton *locateUserButton;
@property (nonatomic, strong) Loot* lastSelectedLoot;
@end

@implementation LootMapViewController
//static const CLLocationDistance scrollUpdateDistance = 200.0;

#pragma mark - Initialization

-(id <Facade>)facade{
    if(_facade == nil)
    {
        _facade = [ServerCallerFacadeFactory createFacade];
    }
    return _facade;
}

- (instancetype)initWithFacade:(id <Facade>)facade
{
    self = [super init];
    if (self) {
        self.facade = facade;
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
    [self zoomIntoUserLocationOnInit];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [[self.mapView selectedAnnotations] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.mapView deselectAnnotation:obj animated:NO];
    }];
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
    CLLocationCoordinate2D userCoordinate = self.mapView.userLocation.coordinate;
    if([self isValidCenterCoordinate:userCoordinate]) {
        CLLocationCoordinate2D newCenterCoordinate = [self zoomIntoLocation:self.mapView.userLocation.coordinate];
        [self loadLootsAtCoordinate:newCenterCoordinate];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User Location is undefined" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)addLootButtonPressed:(id)sender {
    CreateLootViewController *viewController = [[CreateLootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - MapView Setup

-(void)zoomIntoUserLocationOnInit
{
    CLLocationCoordinate2D defaultZoomInCoordinate = CLLocationCoordinate2DMake(47.22693, 8.8189);
    CLLocationCoordinate2D userCoordinate = self.mapView.userLocation.coordinate;
    CLLocationCoordinate2D newCenterCoordinate;
    if([self isValidCenterCoordinate:userCoordinate]) {
        newCenterCoordinate = [self zoomIntoLocation:self.mapView.userLocation.coordinate];
    } else {
         newCenterCoordinate = [self zoomIntoLocation:defaultZoomInCoordinate];
    }
    [self loadLootsAtCoordinate:newCenterCoordinate];
}

-(BOOL)isValidCenterCoordinate:(CLLocationCoordinate2D)coordinate
{
    return (coordinate.latitude <= 0.1 && coordinate.longitude <= 0.1)?false:CLLocationCoordinate2DIsValid(coordinate);
}

-(CLLocationCoordinate2D)zoomIntoLocation:(CLLocationCoordinate2D)coordinate
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
    return region.center;
    //[self loadLootsAtCoordinate:coordinate];
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    //[self DEBUGlootCreatorAtCoordinate:self.mapView.centerCoordinate];
//    NSLog(@"regionDidChangeAnimated");
//    NSLog(@"Span latDelta:%f, longDelta:%f", self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta);
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.centerCoordinate;
//    mapRegion.span.latitudeDelta = 0.3;
//    mapRegion.span.longitudeDelta = 0.3;
//    double lat = mapRegion.center.latitude;
//    double lng = mapRegion.center.longitude;
//    CLLocation *before = [[CLLocation alloc] initWithLatitude:self.lastLocationCoordinate.latitude longitude:self.lastLocationCoordinate.longitude];
//    CLLocation *now = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
//
//    CLLocationDistance distance = ([before distanceFromLocation:now]);
//    NSLog(@"Scrolled distance: %@", [NSString stringWithFormat:@"%.02f", distance]);
    
    //if( distance > scrollUpdateDistance )
    double widthOfViewPort = self.mapView.region.span.longitudeDelta/4*111*1000;
    CLLocation* centerLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    CLLocation* lastLocation = [[CLLocation alloc] initWithLatitude:self.lastLocationCoordinate.latitude longitude:self.lastLocationCoordinate.longitude];
    double distanceBetween = [lastLocation distanceFromLocation:centerLocation];
    NSLog(@"widhofviewport = %f --- distancebetween = %f", widthOfViewPort, distanceBetween);
    if(widthOfViewPort < distanceBetween)
    {
        NSLog(@"Center Latitude: %f Longitude: %f", [self.mapView centerCoordinate].latitude, [self.mapView centerCoordinate].longitude);
        [self loadLootsAtCoordinate:[self.mapView centerCoordinate]];
        
        self.lastLocationCoordinate = CLLocationCoordinate2DMake(mapRegion.center.latitude, mapRegion.center.longitude);
    }
    
}

//-(void)DEBUGlootCreatorAtCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    id<ServerCaller> serverCaller = [ServerCallerFactory createServerCaller];
//    Loot* tempLoot = [Loot new];
//    tempLoot.title = @"AUTOMATIC";
//    tempLoot.summary = @"blaablalblba";
//    tempLoot.created = [NSDate date];
//    tempLoot.radius = [NSNumber numberWithInt:50];
//    User* user = [User new];
//    user.userName = @"Mario";
//    user.email = @"mario@test.ch";
//    tempLoot.creator = user;
//    Coordinate* coord = [[Coordinate alloc] initWithCoordinate2D:coordinate];
//    tempLoot.coord = coord;
//    [serverCaller postLoot:tempLoot onSuccess:^(Loot *loot) {
//        NSLog(@"ROBOT SUCCESSFULL");
//    } onFailure:^(NSError *error) {
//        
//    }];
//}

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

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController != self.navigationController){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    return YES;
}

#pragma mark - Loading Data from Server

-(void)loadLootsAtCoordinate:(CLLocationCoordinate2D)coordinate {
    MKCoordinateSpan visibleSpanRegion = self.mapView.region.span;
    int distance = (visibleSpanRegion.latitudeDelta*111 / 2)*1000;
    [self.facade getLootsAtCoordinate:coordinate inDistance:[NSNumber numberWithInt:distance] onSuccess:^(NSArray *loots) {
        NSMutableArray* newLoots = [NSMutableArray arrayWithArray:loots];
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:newLoots];
//        [newLoots removeObjectsInArray:[self.mapView annotations]];
//        [self.mapView addAnnotations:newLoots];
//        NSLog(@"%d", [[self.mapView annotations] count]);
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
