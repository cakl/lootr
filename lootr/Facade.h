//
//  Facade.h
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Loot.h"
#import "Report.h"

@protocol Facade <NSObject>
-(void)getLootsAtCoordinate:(CLLocationCoordinate2D)coordinate inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
-(void)getLootsAtCurrentPositionWithLimitedCount:(NSUInteger)count onSuccess:(void(^)(NSArray* loots))success onFailure:(void (^)(NSError* error))failure;
-(void)postLoot:(Loot*)loot atCurrentLocationOnSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError*error))failure;
-(void)getLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void (^)(NSError* error))failure;
-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Content* loot))success onFailure:(void (^)(NSError* error))failure;
-(void)postReport:(Report*)report onSuccess:(void(^)(Report* loot))success onFailure:(void (^)(NSError* error))failure;

@end
