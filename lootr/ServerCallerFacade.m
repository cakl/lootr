//
//  ServerCallerFacade.m
//  lootr
//
//  Created by Sebastian Bock on 28.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "ServerCallerFacade.h"
#import "CoreLocationDelegate.h"
#import "ServerCaller.h"
#import "ServerCallerFactory.h"

@interface ServerCallerFacade ()
@property (nonatomic, strong) CoreLocationDelegate* locationDelegate;
@property (nonatomic, strong) id<ServerCaller> serverCaller;
@end

@implementation ServerCallerFacade

-(CoreLocationDelegate*)locationDelegate{
    if(_locationDelegate) return _locationDelegate;
    _locationDelegate = [CoreLocationDelegate sharedInstance];
    return _locationDelegate;
}

-(id <ServerCaller>)serverCaller{
    if (_serverCaller == nil)
    {
        _serverCaller = [ServerCallerFactory createServerCaller];
    }
    return _serverCaller;
}

-(instancetype)initWithLocationDelegate:(CoreLocationDelegate*)locationDelegate andServerCaller:(id<ServerCaller>)serverCaller{
    self = [super init];
    if (self) {
        self.locationDelegate = locationDelegate;
        self.serverCaller = serverCaller;
    }
    return self;
}

-(void) getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure{
    NSNumber* latitude = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:coordinate.longitude];
    [self.serverCaller getLootsAtLatitude:latitude andLongitude:longitude inDistance:distance onSuccess:^(NSArray *loots) {
        success(loots);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

@end
