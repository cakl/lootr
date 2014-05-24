//
//  CoreLocationDelegateStub.h
//  lootr
//
//  Created by Sebastian Bock on 24.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CoreLocationDelegate.h"

@interface CoreLocationDelegateStub : CoreLocationDelegate
- (instancetype)initWithCurrentLocation:(CLLocation*)location;
@end
