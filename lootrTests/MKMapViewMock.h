//
//  MKMapViewMock.h
//  lootr
//
//  Created by Sebastian Bock on 07.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapViewMock : MKMapView
@property (nonatomic) CLLocationCoordinate2D mockCenterCoordinate;
@end
