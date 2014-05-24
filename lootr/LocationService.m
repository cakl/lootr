//
//  LocationService.m
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LocationService.h"

@interface LocationService ()
@property (nonatomic, strong) CoreLocationDelegate* locationDelegate;
@end

@implementation LocationService

-(CoreLocationDelegate*)locationDelegate{
    if(_locationDelegate) return _locationDelegate;
    _locationDelegate = [CoreLocationDelegate sharedInstance];
    return _locationDelegate;
}

-(instancetype)initWithLocationDelegate:(CoreLocationDelegate*)locationDelegate{
    self = [super init];
    if (self) {
        self.locationDelegate = locationDelegate;
    }
    return self;
}

-(void)startLocationService
{
    [self.locationDelegate startUpdatingLocation];
}

-(void)stopLocationService
{
    [self.locationDelegate stopUpdatingLocation];
}

-(BOOL)isLocationServiceAuthorized
{
    return [self.locationDelegate isAuthorized];
}

//TODO: erklaeren warum kupplung an pure data object loot sinn macht: zuviel distance checks in GUI
-(DistanceTreshold)getDistanceThresholdfromCurrentLocationToLoot:(Loot*)loot
{
    NSError* error = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&error];
    CLLocation* lootLocation = [loot.coord asCLLocation];
    if(currentLocation && lootLocation){
        int distance = (int) [lootLocation distanceFromLocation:currentLocation];
        if(distance < DistanceTresholdFiveMeters){
            return DistanceTresholdFiveMeters;
        } else if (distance < DistanceTresholdTenMeters){
            return DistanceTresholdTenMeters;
        } else if (distance < DistanceTresholdFiftyMeters){
            return DistanceTresholdFiftyMeters;
        } else if (distance < DistanceTresholdHundredMeters){
            return DistanceTresholdHundredMeters;
        } else if (distance < DistanceTresholdFiveHundredMeters){
            return DistanceTresholdFiveHundredMeters;
        } else if (distance > DistanceTresholdFiveHundredMeters){
            return DistanceTresholdMoreThanFiveHundredMeters;
        } else {
            return DistanceTresholdUndetermined;
        }
    } else {
        return DistanceTresholdUndetermined;
    }
}

-(BOOL)isCurrentLocationInRadiusOfLoot:(Loot*)loot
{
    NSError* error = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&error];
    if(currentLocation){
        DistanceTreshold threshold = [self getDistanceThresholdfromCurrentLocationToLoot:loot];
        if((int)threshold <= (int)[loot getRadiusAsAccuracy]){
            return YES;
        }
    }
    return NO;
}


@end
