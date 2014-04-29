//
//  Facade.h
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol Facade <NSObject>
-(void) getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
-(void) getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate withLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray *loots))success onFailure:(void (^)(NSError *error))failure;
-(void) getLootsAtCurrentPositionWithLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray *loots))success onFailure:(void (^)(NSError *error))failure;
@end
