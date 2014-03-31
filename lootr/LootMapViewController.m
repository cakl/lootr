//
//  LootViewViewController.m
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootMapViewController.h"
#import "ServerCaller.h"
#import "RestKitServerCaller.h"
#import "Loot+Annotation.h"


@interface LootMapViewController ()
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D lastLocationCoordinate;
@end

@implementation LootMapViewController
static const CLLocationDistance scrollUpdateDistance = 200.0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"MapTabIconActive"];
    
    
}

-(void)viewWillAppear:(BOOL)animated
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
        // do something awesome
        NSLog(@"Center Latitude: %f Longitude: %f", [self.mapView centerCoordinate].latitude, [self.mapView centerCoordinate].longitude);
         //LootAnnotation* exampleAnnotation = [[LootAnnotation alloc] initWithTitle:@"testLoot" andCoordinate:[self.mapView centerCoordinate]];
        //[self.mapView addAnnotation:exampleAnnotation];
        
        id <ServerCaller> serverCaller = [[RestKitServerCaller alloc] initWithObjectManager:[RKObjectManager sharedManager]];
        
        [serverCaller getLootsAtLatitude:[NSNumber numberWithFloat:3.14] andLongitude:[NSNumber numberWithFloat:3.14] inDistance:[NSNumber numberWithInt:100] onSuccess:^(NSArray *loots) {
            NSLog(@"%@", loots);
            [self.mapView addAnnotations:loots];
            NSLog(@"%i", [[self.mapView annotations] count]);
        } onFailure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    self.lastLocationCoordinate = CLLocationCoordinate2DMake(mapRegion.center.latitude, mapRegion.center.longitude);
    
}

/*
 - (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
 MKCoordinateRegion region;
 MKCoordinateSpan span;
 span.latitudeDelta = 0.100;
 span.longitudeDelta = 0.100;
 CLLocationCoordinate2D location;
 location.latitude = aUserLocation.coordinate.latitude;
 location.longitude = aUserLocation.coordinate.longitude;
 region.span = span;
 region.center = location;
 [aMapView setRegion:region animated:YES];
 }
 */
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
