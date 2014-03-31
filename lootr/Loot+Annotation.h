//
//  Loot+Annotation.h
//  lootr
//
//  Created by Sebastian Bock on 31.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "Loot.h"
#import <MapKit/MapKit.h>

@interface Loot (Annotation) <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@end
