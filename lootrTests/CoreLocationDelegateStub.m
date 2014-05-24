//
//  CoreLocationDelegateStub.m
//  lootr
//
//  Created by Sebastian Bock on 24.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CoreLocationDelegateStub.h"

@interface CoreLocationDelegateStub ()
@property (nonatomic, strong) CLLocation* location;
@end

@implementation CoreLocationDelegateStub

- (instancetype)initWithCurrentLocation:(CLLocation*)location
{
    self = [super init];
    if (self) {
        _location = location;
    }
    return self;
}

-(CLLocation*)getCurrentLocationWithError:(NSError**)error
{
    return self.location;
}

@end
