//
//  ServerCaller.h
//  lootr
//
//  Created by Sebastian Bock on 30.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loot.h"
#import "Report.h"

//combinatorial explosion smell????

@protocol ServerCaller <NSObject>
-(void) getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
-(void)getLootByIdentifier:(NSNumber*)identifier onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure;
-(void)postLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure;
-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Content* content))success onFailure:(void(^)(NSError* error))failure;
-(void)getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude withLimitedCount:(NSNumber*)count onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
-(void)postUser:(User*)user onSuccess:(void(^)(User* user))success onFailure:(void(^)(NSError* error))failure;
-(void)postReport:(Report*)report onSuccess:(void(^)(Report* report))success onFailure:(void(^)(NSError* error))failure;
-(void)setAuthorizationToken:(NSString*)token;
-(void)clearAuthorizationToken;
@end
