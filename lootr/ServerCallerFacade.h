//
//  ServerCallerFacade.h
//  lootr
//
//  Created by Sebastian Bock on 28.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facade.h"
#import <CoreLocation/CoreLocation.h>

@interface ServerCallerFacade : NSObject <Facade>
-(void) getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
-(void) getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate withLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray *loots))success onFailure:(void (^)(NSError *error))failure;
-(void) getLootsAtCurrentPositionWithLimitedCount:(NSUInteger)count onSuccess:(void (^)(NSArray *loots))success onFailure:(void (^)(NSError *error))failure;
-(void)postLoot:(Loot*)loot atCurrentLocationOnSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError *error))failure;
-(void) getLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError *error))failure;
-(void) postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Content* loot))success onFailure:(void (^)(NSError *error))failure;
-(void)postReport:(Report*)report onSuccess:(void(^)(Report* loot))success onFailure:(void (^)(NSError *error))failure;
@end
