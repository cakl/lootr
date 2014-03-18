//
//  RESTKitInitializer.m
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RESTKitInitializer.h"
#import "Loot.h"
#import "User.h"

#define API_URL @"http://152.96.56.70:8080/lootrserver/"
#define LOOTS_PATH_PATTERN @"webapi/loots/X/:xCoordinate/Y/:yCoordinate"


@interface RESTKitInitializer()
@property (nonatomic, strong) RKObjectManager *manager;
@property (nonatomic, strong) RKObjectMapping *lootsMapping;
@property (nonatomic, strong) RKObjectMapping *userMapping;
@property (nonatomic, strong) RKResponseDescriptor *lootsRD;
@property (nonatomic, strong) RKResponseDescriptor *userRD;
- (void)addGETMapping;
@end

@implementation RESTKitInitializer

-(void) setupRESTKit:(NSError **) error{
    self.manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:API_URL]];
    self.manager.requestSerializationMIMEType = RKMIMETypeJSON;
}

- (RKObjectMapping *)lootsMapping {
    if(_lootsMapping) {
        return _lootsMapping;
    }
    _lootsMapping = [RKObjectMapping mappingForClass:[Loot class]];
    [_lootsMapping addAttributeMappingsFromDictionary:@{
                                                         @"id": @"identifier",
                                                         @"dateCreated": @"created",
                                                         @"description": @"description",
                                                         @"latitude": @"latitude",
                                                         @"longitude" : @"longitude",
                                                         @"title" : @"title",
                                                         @"accuracy" : @"accuracy"
                                                         }];
    
    [_lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:self.userMapping]];
    
    return _lootsMapping;
}

- (RKObjectMapping *)userMapping {
    if(_userMapping) {
        return _userMapping;
    }
    _userMapping = [RKObjectMapping mappingForClass:[User class]];
    [_lootsMapping addAttributeMappingsFromDictionary:@{
                                                        @"username": @"userName"
                                                        }];
    
    return _userMapping;
}

-(RKResponseDescriptor*)lootsRD{
    if(_lootsRD) return _lootsRD;
    _lootsRD = [RKResponseDescriptor responseDescriptorWithMapping:self.lootsMapping method:RKRequestMethodGET pathPattern:LOOTS_PATH_PATTERN keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return _lootsRD;
}

-(RKResponseDescriptor*)userRD{
    if(_userRD) return _userRD;
    _userRD = [RKResponseDescriptor responseDescriptorWithMapping:self.userMapping method:RKRequestMethodGET pathPattern:LOOTS_PATH_PATTERN keyPath:@"creator" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return _userRD;
}

- (void)addGETMapping {
    [self.manager addResponseDescriptor:self.lootsRD];
    [self.manager addResponseDescriptor:self.userRD];
}

@end
