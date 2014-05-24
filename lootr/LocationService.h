//
//  LocationService.h
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreLocationDelegate.h"
#import "Loot.h"

typedef NS_ENUM(int, DistanceTreshold)
{
    DistanceTresholdFiveMeters = 5,
    DistanceTresholdTenMeters = 10,
    DistanceTresholdFiftyMeters = 50,
    DistanceTresholdHundredMeters = 100,
    DistanceTresholdFiveHundredMeters = 500,
    DistanceTresholdMoreThanFiveHundredMeters = 1000,
    DistanceTresholdUndetermined = 10000
};

@interface LocationService : NSObject
-(instancetype)initWithLocationDelegate:(CoreLocationDelegate*)locationDelegate;
-(DistanceTreshold)getDistanceThresholdfromCurrentLocationToLoot:(Loot*)loot;
-(BOOL)isCurrentLocationInRadiusOfLoot:(Loot*)loot;
-(void)startLocationService;
-(void)stopLocationService;
-(BOOL)isLocationServiceAuthorized;

@end
