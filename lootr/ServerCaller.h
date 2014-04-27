//
//  ServerCaller.h
//  lootr
//
//  Created by Sebastian Bock on 30.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loot.h"

@protocol ServerCaller <NSObject>
-(void) getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
-(void) getLootByIdentifier:(NSNumber*)identifier onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure;
-(void) postLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure;
-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure;
@end
