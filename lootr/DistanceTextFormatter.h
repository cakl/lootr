//
//  DistanceTextFormatter.h
//  lootr
//
//  Created by Sebastian Bock on 26.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationService.h"

@interface DistanceTextFormatter : NSObject
+(NSString*)distanceTextOfThreshold:(DistanceTreshold)distanceThreshold;
+(NSString*)longDistanceTextOfThreshold:(DistanceTreshold)distanceThreshold;

@end
