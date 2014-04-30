//
//  LocationService.h
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Loot.h"

@interface LocationService : NSObject

-(NSInteger)getDistanceToLoot:(Loot*)loot withError:(NSError**)error;

@end
