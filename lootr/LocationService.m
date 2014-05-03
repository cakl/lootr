//
//  LocationService.m
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LocationService.h"
#import "CoreLocationDelegate.h"

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

-(NSInteger)getDistanceToLoot:(Loot*)loot withError:(NSError**)error{
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:error];
    if(currentLocation){
        CLLocation* lootLocation = [[CLLocation alloc] initWithLatitude:[loot.coord.latitude doubleValue] longitude:[loot.coord.longitude doubleValue]];
        CLLocationDistance distance = [lootLocation distanceFromLocation:currentLocation];
        return (NSInteger) distance;
    } else {
        return -1;
    }
}

-(DistanceTreshold)getDistanceThresholdfromCurrentLocationToLocation:(CLLocation*)location
{
    NSError* error = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&error];
    if(currentLocation){
        int distance = (int) [location distanceFromLocation:currentLocation];
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


@end
