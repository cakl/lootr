//
//  LocationService.m
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LocationService.h"
#import "CoreLocationDelegate.h"
#import "Loot.h"

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


@end
