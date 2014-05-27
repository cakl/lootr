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
#import "UserService.h"
#import "Errors.h"
#import "LocationService.h"

@interface ServerCallerFacade ()
@property (nonatomic, strong) CoreLocationDelegate* locationDelegate;
@property (nonatomic, strong) id<ServerCaller> serverCaller;
@property (nonatomic, strong) UserService* userService;
@property (nonatomic, strong) LocationService* locationService;

@end

@implementation ServerCallerFacade

#pragma mark - Initialization

-(CoreLocationDelegate*)locationDelegate {
    if(_locationDelegate) return _locationDelegate;
    _locationDelegate = [CoreLocationDelegate sharedInstance];
    return _locationDelegate;
}

-(id <ServerCaller>)serverCaller {
    if(_serverCaller == nil) {
        _serverCaller = [ServerCallerFactory createServerCaller];
    }
    return _serverCaller;
}

-(UserService*)userService {
    if(_userService == nil) {
        _userService = [[UserService alloc] initWithKeyChainServiceName:keychainUserServiceName userDefaults:[NSUserDefaults standardUserDefaults]];
    }
    return _userService;
}

-(LocationService*)locationService {
    if(_locationService == nil) {
        _locationService = [[LocationService alloc] init];
    }
    return _locationService;
}

-(instancetype)initWithLocationDelegate:(CoreLocationDelegate*)locationDelegate andServerCaller:(id<ServerCaller>)serverCaller {
    self = [super init];
    if(self) {
        self.locationDelegate = locationDelegate;
        self.serverCaller = serverCaller;
    }
    return self;
}

#pragma mark - Server IO

-(void)getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure {
    NSNumber* latitude = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:coordinate.longitude];
    [self.serverCaller getLootsAtLatitude:latitude andLongitude:longitude inDistance:distance onSuccess:^(NSArray* loots) {
        success(loots);
    } onFailure:^(NSError* error) {
        failure(error);
    }];
}

-(void)getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate withLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray* loots))success onFailure:(void (^)(NSError* error))failure {
    NSNumber* latitude = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:coordinate.longitude];
    NSNumber* limitedCount = [NSNumber numberWithUnsignedInteger:count];
    [self.serverCaller getLootsAtLatitude:latitude andLongitude:longitude withLimitedCount:limitedCount onSuccess:^(NSArray* loots) {
        success(loots);
    } onFailure:^(NSError* error) {
        failure(error);
    }];
}

-(void)getLootsAtCurrentPositionWithLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray* loots))success onFailure:(void (^)(NSError* error))failure {
    NSError* positionError = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&positionError];
    if(currentLocation) {
        [self getLootsAtCoordinate:currentLocation.coordinate withLimitedCount:count onSuccess:^(NSArray* loots) {
            success(loots);
        } onFailure:^(NSError* error) {
            failure(error);
        }];
    } else {
        failure(positionError);
    }
}

-(void)getLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError* error))failure {
    [self.serverCaller getLootByIdentifier:loot.identifier onSuccess:^(Loot* loot) {
        success(loot);
    } onFailure:^(NSError* error) {
        failure(error);
    }];
}

-(void)postLoot:(Loot*)loot atCurrentLocationOnSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError* error))failure {
    NSError* positionError = nil;
    NSError* userError = nil;
    NSError* cityError = nil;
    CLLocation* currentLocation = [self.locationDelegate getCurrentLocationWithError:&positionError];
    User* currentUser = [self.userService getLoggedInUserWithError:&userError];
    if(!positionError && !userError) {
        Coordinate* currentCoordinate = [[Coordinate alloc] init];
        currentCoordinate.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        currentCoordinate.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
        NSString* currentCity = [self.locationDelegate getCurrentCityWithError:&cityError];
        loot.coord = currentCoordinate;
        loot.coord.location = (cityError)?NSLocalizedString(@"servercallerfacade.cityunknown", nil):currentCity;
        loot.creator = currentUser;
        [self.serverCaller postLoot:loot onSuccess:^(Loot* loot) {
            success(loot);
        } onFailure:^(NSError* error) {
            failure(error);
        }];
    } else {
        (positionError)?failure(positionError):failure(userError);
    }
}

-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Content* loot))success onFailure:(void (^)(NSError* error))failure {
    NSError* userError = nil;
    User* currentUser = [self.userService getLoggedInUserWithError:&userError];
    if(!userError) {
        if([self.locationService isCurrentLocationInRadiusOfLoot:loot]) {
            content.creator = currentUser;
            [self.serverCaller postContent:content onLoot:loot withImage:image onSuccess:^(Content* content) {
                success(content);
            } onFailure:^(NSError* error) {
                failure(error);
            }];
        } else {
            NSError* distanceError = [Errors produceErrorWithErrorCode:outofradiusError withUnderlyingError:nil];
            failure(distanceError);
        }
    } else {
        failure(userError);
    }
}

-(void)postReport:(Report*)report onSuccess:(void(^)(Report* loot))success onFailure:(void (^)(NSError* error))failure {
    NSError* userError = nil;
    User* currentUser = [self.userService getLoggedInUserWithError:&userError];
    if(!userError) {
        report.creator = currentUser;
        [self.serverCaller postReport:report onSuccess:^(Report* report) {
            success(report);
        } onFailure:^(NSError* error) {
            failure(error);
        }];
    } else {
        failure(userError);
    }
}

@end
