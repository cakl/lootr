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

-(void) getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate withLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray *loots))success onFailure:(void (^)(NSError *error))failure{
    NSNumber* latitude = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:coordinate.longitude];
    NSNumber* limitedCount = [NSNumber numberWithUnsignedInteger:count];
    [self.serverCaller getLootsAtLatitude:latitude andLongitude:longitude withLimitedCount:limitedCount onSuccess:^(NSArray *loots) {
        success(loots);
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

-(void) getLootsAtCurrentPositionWithLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray *loots))success onFailure:(void (^)(NSError *error))failure{
    NSError* positionError = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&positionError];
    if(currentLocation){
        [self getLootsAtCoordinate:currentLocation.coordinate withLimitedCount:count onSuccess:^(NSArray *loots) {
            success(loots);
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } else {
        failure(positionError);
    }
}

-(void)getLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError *error))failure{
    NSError* positionError = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&positionError];
    if(currentLocation){
        if([self checkIfCurrentLocation:currentLocation isInRadiusOfLoot:loot]){
            [self.serverCaller getLootByIdentifier:loot.identifier onSuccess:^(Loot *loot) {
                success(loot);
            } onFailure:^(NSError *error) {
                failure(error);
            }];
        }
    } else {
        failure(positionError);
    }
}

-(void)postLoot:(Loot*)loot atCurrentLocationOnSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError *error))failure{
    NSError* positionError = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&positionError];
    if(currentLocation){
        Coordinate* currentCoordinate = [[Coordinate alloc] init];
        currentCoordinate.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        currentCoordinate.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
        loot.coord = currentCoordinate;
        [self.serverCaller postLoot:loot onSuccess:^(Loot *loot) {
            success(loot);
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } else {
        failure(positionError);
    }
}

-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Content* loot))success onFailure:(void (^)(NSError *error))failure{
    NSError* positionError = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&positionError];
    if(currentLocation){
        if([self checkIfCurrentLocation:currentLocation isInRadiusOfLoot:loot]){
            [self.serverCaller postContent:content onLoot:loot withImage:image onSuccess:^(Content *content) {
                success(content);
            } onFailure:^(NSError *error) {
                failure(error);
            }];
        }
    } else {
        failure(positionError);
    }
}

-(BOOL)checkIfCurrentLocation:(CLLocation*)currentLocation isInRadiusOfLoot:(Loot*)loot{
    CLLocation* lootLocation = [[CLLocation alloc] initWithLatitude:[loot.coord.latitude doubleValue] longitude:[loot.coord.longitude doubleValue]];
    return ([lootLocation distanceFromLocation:currentLocation] <= [loot.radius doubleValue]);
}

@end
