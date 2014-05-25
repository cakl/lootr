//
//  MKMapViewMock.m
//  lootr
//
//  Created by Sebastian Bock on 07.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "MKMapViewMock.h"

@implementation MKMapViewMock

-(CLLocationCoordinate2D)centerCoordinate {
    return self.mockCenterCoordinate;
}

@end
