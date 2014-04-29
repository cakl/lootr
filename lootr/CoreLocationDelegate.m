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
@end

@implementation CoreLocationDelegate
static NSString* errorDomain = @"ch.hsr.lootr";
static const NSInteger errorCode = 1000;
static const double updateDistance = 20.0;

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
    }
    return self;
}

-(void)startUpdatingLocation{
    [self.locationManager startUpdatingLocation];
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

-(BOOL)isAuthorized{
    return (CLLocationManager.authorizationStatus != kCLAuthorizationStatusAuthorized);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _location = [locations lastObject];
}

@end
