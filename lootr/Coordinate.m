//
//  Coordinate.m
//  lootr
//
//  Created by Sebastian Bock on 24.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

-(CLLocation*)asCLLocation{
    return [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
}

@end
