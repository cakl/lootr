//
//  CoreLocationDelegate.m
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CoreLocationDelegate.h"

@interface CoreLocationDelegate ()
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (atomic, strong, readonly) CLLocation* location;
@property (atomic, strong) CLLocation* lastLocation;
@property (atomic, strong) NSString* city;
@property (nonatomic, strong) CLGeocoder* geocoder;
@end

@implementation CoreLocationDelegate
static NSString* errorDomain = @"ch.hsr.lootr";
static const NSInteger errorCode = 1000;
static const double updateDistance = 20.0;
static const double geocodeUpdateDistance = 1000;

+(CoreLocationDelegate*)sharedInstance
{
    static CoreLocationDelegate* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreLocationDelegate alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = updateDistance;
        self.geocoder = [[CLGeocoder alloc] init];
        self.lastLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    }
    return self;
}

-(void)startUpdatingLocation{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.locationManager startUpdatingLocation]; // TODO: describe this hack.
    });
}

-(void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

-(CLLocation*)getCurrentLocationWithError:(NSError**)error{
    if(!self.locationManager.location){
        *error = [NSError errorWithDomain:errorDomain code:errorCode userInfo:nil];
        return nil;
    }
    if(!self.location){
        [self.locationManager startUpdatingLocation];
        return self.locationManager.location;
    }
    return self.location;
}

-(NSString*)getCurrentCityWithError:(NSError**)error{
    if(!self.city){
        *error = [NSError errorWithDomain:@"ch.hsr.lootr" code:1000 userInfo:nil];
        return nil;
    }
    return self.city;
}

-(BOOL)isAuthorized{
    return (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorized);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _location = [locations lastObject];
    double distance = [self.lastLocation distanceFromLocation:self.location];
    if(distance > geocodeUpdateDistance || distance == 0 ){
        [self geocodeCityByLocation:self.location];
        self.lastLocation = self.location;
    }
}

-(void)geocodeCityByLocation:(CLLocation*)location
{
    if(!self.geocoder.geocoding){
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if(error){
                self.city = nil;
            } else {
                self.city = [[placemarks firstObject] locality];
            }
        }];
    }
}

@end
