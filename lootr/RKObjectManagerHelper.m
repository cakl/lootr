//
//  RKObjectManagerHelper.m
//  lootr
//
//  Created by Sebastian Bock on 27.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RKObjectManagerHelper.h"
#import "Loot.h"

@implementation RKObjectManagerHelper
static NSString* const lootsByDistancePathPattern = @"/lootrserver/api/v1/loots/latitude/:lat/longitude/:long/distance/:dist";
static NSString* const lootsByIdPathPattern = @"/lootrserver/api/v1/loots/:id";
static NSString* const lootsPostPathPattern = @"/lootrserver/api/v1/loots";

+(void) configureRKObjectManagerWithRequestRescriptors:(RKObjectManager*)objectManager{
    RKObjectMapping* lootsMapping = [RKObjectMapping mappingForClass:[Loot class]];
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    RKObjectMapping* coordinateMapping = [RKObjectMapping mappingForClass:[Coordinate class]];
    RKObjectMapping* contentMapping = [RKObjectMapping mappingForClass:[Content class]];
    RKObjectMapping* lootsPostMapping = [RKObjectMapping mappingForClass:[Loot class]];
    
    [lootsMapping addAttributeMappingsFromDictionary:@{
                                                      @"id": @"identifier",
                                                      @"dateCreated": @"created",
                                                      @"dateUpdated": @"updated",
                                                      @"summary": @"summary",
                                                      @"title" : @"title",
                                                      @"radius" : @"radius"
                                                      }];
    
    [lootsPostMapping addAttributeMappingsFromDictionary:@{
                                                       @"summary": @"summary",
                                                       @"title" : @"title",
                                                       @"radius" : @"radius"
                                                       }];
    
    [userMapping addAttributeMappingsFromDictionary:@{
                                                    @"username": @"userName"
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
    
    
    [lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:userMapping]];
    [lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coordinate" toKeyPath:@"coord" withMapping:coordinateMapping]];
    [lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contents" toKeyPath:@"contents" withMapping:contentMapping]];
    [contentMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:userMapping]];
    
    [lootsPostMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coordinate" toKeyPath:@"coord" withMapping:coordinateMapping]];
    [lootsPostMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:userMapping]];
    
    RKResponseDescriptor* lootsByDistanceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lootsMapping method:RKRequestMethodGET pathPattern:lootsByDistancePathPattern keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor* lootsByIdResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lootsMapping method:RKRequestMethodGET pathPattern:lootsByIdPathPattern keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKResponseDescriptor* lootsPostResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:lootsMapping method:RKRequestMethodPOST pathPattern:lootsPostPathPattern keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptor:lootsByDistanceResponseDescriptor];
    [objectManager addResponseDescriptor:lootsByIdResponseDescriptor];
    [objectManager addResponseDescriptor:lootsPostResponseDescriptor];
    
    RKRequestDescriptor* lootPostRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[lootsPostMapping inverseMapping] objectClass:[Loot class] rootKeyPath:@"loots" method:RKRequestMethodPOST];
    
    [objectManager addRequestDescriptor:lootPostRequestDescriptor];
    
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
}

@end
