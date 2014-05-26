//
//  ServerCaller.m
//  lootr
//
//  Created by Sebastian Bock on 29.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RestKitServerCaller.h"
#import "ServerErrorHandler.h"

@interface RestKitServerCaller ()
@property (nonatomic, strong) RKObjectManager* objectManager;

@end

@implementation RestKitServerCaller

static NSString *const apiPath = @"/lootrserver/api/v1";
static NSString *const lootsByDistanceFormat = @"%@/loots/latitude/%@/longitude/%@/distance/%@";
static NSString *const lootByIdentifierFormat = @"%@/loots/%@";
static NSString *const lootByCountFormat = @"%@/loots/latitude/%@/longitude/%@/count/%@";
static NSString *const postLootFormat = @"%@/loots";
static NSString *const postUserFormat = @"%@/users/login";
static NSString *const postContentFormat = @"%@/contents";
static NSString *const postReportFormat = @"%@/reports";
static NSString *const contentName = @"file";
static NSString *const contentFileName = @"photo.jpg";
static NSString *const contentMimeType = @"image/jpeg";
static NSString *const contentIdentifierBoundaryName = @"id";
static NSString *const contentUserBoundaryName = @"username";
static CGFloat const compressionQuality = 0.8;

-(instancetype)initWithObjectManager:(RKObjectManager*)objectManager {
    self = [super init];
    if(self) {
        _objectManager = objectManager;
    }
    return self;
}

-(void)getObjectsAtPath:(NSString*)path parameters:(NSDictionary *)parameters success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [self.objectManager getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success(operation, mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(operation, [ServerErrorHandler selectErrorByOperation:operation andError:error]);
    }];
}

-(void)postObject:(id)object path:(NSString*)path parameters:(NSDictionary *)parameters success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    [self.objectManager postObject:object path:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success(operation, mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(operation, [ServerErrorHandler selectErrorByOperation:operation andError:error]);
    }];
}

-(void)getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude inDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure {
    [self getObjectsAtPath:[NSString stringWithFormat:lootsByDistanceFormat, apiPath, latitude, longitude, distance] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)getLootByIdentifier:(NSNumber*)identifier onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure {
    [self getObjectsAtPath:[NSString stringWithFormat:lootByIdentifierFormat, apiPath, identifier] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)getLootsAtLatitude:(NSNumber*)latitude andLongitude:(NSNumber*)longitude withLimitedCount:(NSNumber*)count onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure {
    [self getObjectsAtPath:[NSString stringWithFormat:lootByCountFormat, apiPath, latitude, longitude, count] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)postLoot:(Loot*)loot onSuccess:(void(^)(Loot* loot))success onFailure:(void(^)(NSError* error))failure {
    [self postObject:loot path:[NSString stringWithFormat:postLootFormat, apiPath] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)postUser:(User*)user onSuccess:(void(^)(User* user))success onFailure:(void(^)(NSError* error))failure {
    [self postObject:user path:[NSString stringWithFormat:postUserFormat, apiPath] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image onSuccess:(void(^)(Content* content))success onFailure:(void(^)(NSError* error))failure {
    NSMutableURLRequest* request = [self.objectManager multipartFormRequestWithObject:content method:RKRequestMethodPOST path:[NSString stringWithFormat:postContentFormat, apiPath] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, compressionQuality) name:contentName fileName:contentFileName mimeType:contentMimeType];
        NSString* nsdataIdentifierString = [NSString stringWithFormat:@"%@", loot.identifier];
        [formData appendPartWithFormData:[nsdataIdentifierString dataUsingEncoding:NSUTF8StringEncoding] name:contentIdentifierBoundaryName];
        NSString* nsdataCreatorString = [NSString stringWithFormat:@"%@", content.creator.userName];
        [formData appendPartWithFormData:[nsdataCreatorString dataUsingEncoding:NSUTF8StringEncoding] name:contentUserBoundaryName];
    }];
    RKObjectRequestOperation* operation = [self.objectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation* operation, RKMappingResult* mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation* operation, NSError* error) {
        failure([ServerErrorHandler selectErrorByOperation:operation andError:error]);
    }];
    [self.objectManager enqueueObjectRequestOperation:operation];
}

-(void)postReport:(Report*)report onSuccess:(void(^)(Report* report))success onFailure:(void(^)(NSError* error))failure {
    [self postObject:report path:[NSString stringWithFormat:postReportFormat, apiPath] parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success([[mappingResult array] firstObject]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

-(void)setAuthorizationToken:(NSString*)token {
    [self.objectManager.HTTPClient setAuthorizationHeaderWithToken:token];
}

-(void)clearAuthorizationToken {
    [self.objectManager.HTTPClient clearAuthorizationHeader];
}

@end
