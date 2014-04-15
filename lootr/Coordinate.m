//
//  Coordinate.m
//  lootr
//
//  Created by Sebastian Bock on 24.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

- (instancetype)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.latitude = [NSNumber numberWithDouble:coordinate.latitude];
        self.longitude = [NSNumber numberWithDouble:coordinate.longitude];
        self.location = @"TODO";
    }
    return self;
}

@end
