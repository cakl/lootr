//
//  Loot+Annotation.m
//  lootr
//
//  Created by Sebastian Bock on 31.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "Loot+Annotation.h"

@implementation Loot (Annotation)

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.coord.latitude doubleValue], [self.coord.longitude doubleValue]);
}

@end
