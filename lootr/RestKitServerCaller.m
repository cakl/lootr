//
//  ServerCaller.m
//  lootr
//
//  Created by Sebastian Bock on 29.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RestKitServerCaller.h"

@interface RestKitServerCaller ()
@property (nonatomic, strong) RKObjectManager* objectManager;
@end

@implementation RestKitServerCaller
static NSString* const apiPath = @"/lootrserver/api/v1";

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
    [self.objectManager getObjectsAtPath:[NSString stringWithFormat:@"%@/loots/latitude/%@/longitude/%@/distance/%@", apiPath, latitude, longitude, distance] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void) getLootByIdentifier:(NSNumber*)identifier onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure
{
    [self.objectManager getObjectsAtPath:[NSString stringWithFormat:@"%@/loots/%@", apiPath, identifier] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void) getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude withLimitedCount:(NSNumber*)count onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure
{
    [self.objectManager getObjectsAtPath:[NSString stringWithFormat:@"%@/loots/latitude/%@/longitude/%@/count/%@", apiPath, latitude, longitude, count] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)postLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure
{
    [self.objectManager postObject:loot path:[NSString stringWithFormat:@"%@/loots", apiPath] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Content* content))success onFailure:(void(^)(NSError* error))failure
{
    NSMutableURLRequest *request = [self.objectManager multipartFormRequestWithObject:content method:RKRequestMethodPOST path:[NSString stringWithFormat:@"%@/contents", apiPath] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"file" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        NSString* nsdataIdentifierString = [NSString stringWithFormat:@"%@", loot.identifier];
        [formData appendPartWithFormData:[nsdataIdentifierString dataUsingEncoding:NSUTF8StringEncoding] name:@"id"];
        NSString* nsdataCreatorString = [NSString stringWithFormat:@"%@", content.creator.userName];
        [formData appendPartWithFormData:[nsdataCreatorString dataUsingEncoding:NSUTF8StringEncoding] name:@"username"];
    }];
    RKObjectRequestOperation *operation = [self.objectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [self.objectManager enqueueObjectRequestOperation:operation];
}

@end
