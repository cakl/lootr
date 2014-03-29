//
//  ServerCaller.m
//  lootr
//
//  Created by Sebastian Bock on 29.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "ServerCaller.h"

@interface ServerCaller ()
@property (nonatomic, strong) RKObjectManager* objectManager;
@end

@implementation ServerCaller

-(instancetype) initWithObjectManager:(RKObjectManager*)objectManager
{
    self = [super init];
    if (self) {
        _objectManager = objectManager;
    }
    return self;
}

-(void) getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure
{
    
    [self.objectManager getObjectsAtPath:[NSString stringWithFormat:@"/lootrserver/api/v1/loots/latitude/%@/longitude/%@/distance/%@", latitude, longitude, distance] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
    }];
}

@end
