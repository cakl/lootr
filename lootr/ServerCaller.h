//
//  ServerCaller.h
//  lootr
//
//  Created by Sebastian Bock on 29.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerCaller : NSObject
-(instancetype) initWithObjectManager:(RKObjectManager*)objectManager;
-(void) getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
@end
