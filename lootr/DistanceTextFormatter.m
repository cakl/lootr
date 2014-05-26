//
//  DistanceTextFormatter.m
//  lootr
//
//  Created by Sebastian Bock on 26.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "DistanceTextFormatter.h"

@implementation DistanceTextFormatter

+(NSString*)distanceTextOfThreshold:(DistanceTreshold)distanceThreshold {
    NSString* distanceUnknownText = NSLocalizedString(@"lootcontentviewcontroller.content.distanceundeterminedlabel", nil);
    NSString* thresholdText;
    switch(distanceThreshold) {
        case DistanceTresholdUndetermined:
        {
            thresholdText = distanceUnknownText;
        }
            break;
        case DistanceTresholdMoreThanFiveHundredMeters:
        {
            thresholdText = [NSString stringWithFormat:@">%im", DistanceTresholdFiveHundredMeters];
        }
            break;
        default:
        {
            thresholdText = [NSString stringWithFormat:@"<%im", distanceThreshold];
        }
            break;
    }
    return thresholdText;
}

+(NSString*)longDistanceTextOfThreshold:(DistanceTreshold)distanceThreshold {
    NSString* distanceText = NSLocalizedString(@"lootcontentviewcontroller.content.distancelabel", nil);
    return [NSString stringWithFormat:@"%@ %@", [self distanceTextOfThreshold:distanceThreshold], distanceText];
}

@end
