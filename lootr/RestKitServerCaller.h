//
//  ServerCaller.h
//  lootr
//
//  Created by Sebastian Bock on 29.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCaller.h"

@interface RestKitServerCaller : NSObject <ServerCaller>
-(instancetype) initWithObjectManager:(RKObjectManager*)objectManager;
-(void) getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
@end
