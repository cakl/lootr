//
//  RKObjectManagerHelper.m
//  lootr
//
//  Created by Sebastian Bock on 27.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RKObjectManagerHelper.h"
#import "Loot.h"
#import "Report.h"

@implementation RKObjectManagerHelper
static NSString* const lootsByDistancePathPattern = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
static NSString* const lootsByCountPathPattern = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/count/:count";
static NSString* const lootsByIdPathPattern = @"/lootrserver/api/v1/loots/:id";
static NSString* const lootsPostPathPattern = @"/lootrserver/api/v1/loots";
static NSString* const contentsPathPattern = @"/lootrserver/api/v1/contents";
static NSString* const usersLoginPathPattern = @"/lootrserver/api/v1/users/login";
static NSString* const reportsPathPattern = @"/lootrserver/api/v1/reports";

+(void)configureRKObjectManagerWithRequestRescriptors:(RKObjectManager*)objectManager{
    RKObjectMapping* lootsMapping = [RKObjectMapping mappingForClass:[Loot class]];
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    RKObjectMapping* coordinateMapping = [RKObjectMapping mappingForClass:[Coordinate class]];
    RKObjectMapping* contentMapping = [RKObjectMapping mappingForClass:[Content class]];
    RKObjectMapping* lootsPostMapping = [RKObjectMapping mappingForClass:[Loot class]];
    RKObjectMapping* userPostMapping = [RKObjectMapping mappingForClass:[User class]];
    RKObjectMapping* reportMapping = [RKObjectMapping mappingForClass:[Report class]];
    RKObjectMapping* lootReportsPostMapping = [RKObjectMapping mappingForClass:[Loot class]];
    
    [lootsMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"identifier",
                                                      @"dateCreated": @"created",
                                                      @"summary": @"summary",
                                                      @"title" : @"title",
                                                      @"radius" : @"radius"
                                                      }];
    
    [userMapping addAttributeMappingsFromDictionary:@{
                                                    @"username": @"userName",
                                                    @"email": @"email",
                                                    @"password": @"passWord",
                                                    @"token": @"token"
                                                    }];
    
    [coordinateMapping addAttributeMappingsFromDictionary:@{
                                                             @"latitude": @"latitude",
                                                             @"longitude": @"longitude",
                                                             @"location": @"location"
                                                             }];
    
    [contentMapping addAttributeMappingsFromDictionary:@{
                                                            @"id": @"identifier",
                                                            @"type": @"type",
                                                            @"url": @"url",
                                                            @"thumb": @"thumb",
                                                            @"dateCreated": @"created"
                                                            }];
    
    [reportMapping addAttributeMappingsFromDictionary:@{
                                                          @"purpose": @"purpose"
                                                          }];
    
    //POST MAPPINGS
    [lootsPostMapping addAttributeMappingsFromDictionary:@{
                                                           @"summary": @"summary",
                                                           @"title" : @"title",
                                                           @"radius" : @"radius"
                                                           }];
    
    [userPostMapping addAttributeMappingsFromDictionary:@{
                                                          @"email": @"email",
                                                          @"password": @"passWord"
                                                          }];
    
    [lootReportsPostMapping addAttributeMappingsFromDictionary:@{
                                                                 @"id": @"identifier",
                                                                 @"title": @"title"
                                                                 }];
    
    
    
    [lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:userMapping]];
    [lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coordinate" toKeyPath:@"coord" withMapping:coordinateMapping]];
    [lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contents" toKeyPath:@"contents" withMapping:contentMapping]];
    [contentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:userMapping]];
    
    [lootsPostMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coordinate" toKeyPath:@"coord" withMapping:coordinateMapping]];
    [lootsPostMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:userMapping]];
    
    [reportMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:userMapping]];
    [reportMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loot" toKeyPath:@"loot" withMapping:lootReportsPostMapping]];
    
    RKResponseDescriptor* lootsByDistanceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lootsMapping method:RKRequestMethodGET pathPattern:lootsByDistancePathPattern keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor* lootsByIdResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lootsMapping method:RKRequestMethodGET pathPattern:lootsByIdPathPattern keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor* lootsPostResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lootsMapping method:RKRequestMethodPOST pathPattern:lootsPostPathPattern keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor* lootsByCountResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lootsMapping method:RKRequestMethodGET pathPattern:lootsByCountPathPattern keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor* userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodPOST pathPattern:usersLoginPathPattern keyPath:@"users" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor* reportResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reportMapping method:RKRequestMethodPOST pathPattern:reportsPathPattern keyPath:@"reports" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:lootsByDistanceResponseDescriptor];
    [objectManager addResponseDescriptor:lootsByIdResponseDescriptor];
    [objectManager addResponseDescriptor:lootsPostResponseDescriptor];
    [objectManager addResponseDescriptor:lootsByCountResponseDescriptor];
    [objectManager addResponseDescriptor:userResponseDescriptor];
    [objectManager addResponseDescriptor:reportResponseDescriptor];
    
    RKRequestDescriptor* lootPostRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[lootsPostMapping inverseMapping] objectClass:[Loot class] rootKeyPath:@"loots" method:RKRequestMethodPOST];
    RKRequestDescriptor* userPostRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[userPostMapping inverseMapping] objectClass:[User class] rootKeyPath:@"users" method:RKRequestMethodPOST];
    RKRequestDescriptor* reportPostRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[reportMapping inverseMapping] objectClass:[Report class] rootKeyPath:@"reports" method:RKRequestMethodPOST];
    
    [objectManager addRequestDescriptor:lootPostRequestDescriptor];
    [objectManager addRequestDescriptor:userPostRequestDescriptor];
    [objectManager addRequestDescriptor:reportPostRequestDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
}

@end
