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

#define LOOTS_PATH_PATTERN @"/lootrserver/api/loots/lat/:lat/long/:long/distance/:dist"


@interface RESTKitInitializer()
@property (nonatomic, strong) RKObjectManager *manager;
@property (nonatomic, strong) RKObjectMapping *lootsMapping;
@property (nonatomic, strong) RKObjectMapping *userMapping;
@property (nonatomic, strong) RKObjectMapping *coordinateMapping;
@property (nonatomic, strong) RKResponseDescriptor *lootsRD;
- (void)addGETMapping;
@end

@implementation RESTKitInitializer

-(id)initWithApiUrl:(NSString*)apiUrl{
    self = [super init];
    if(self){
        self.manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:apiUrl]];
        self.manager.requestSerializationMIMEType = RKMIMETypeJSON;
        [self addGETMapping];
    }
    return self;
}

- (RKObjectMapping *)lootsMapping {
    if(_lootsMapping) {
        return _lootsMapping;
    }
    _lootsMapping = [RKObjectMapping mappingForClass:[Loot class]];
    [_lootsMapping addAttributeMappingsFromDictionary:@{
                                                         @"id": @"identifier",
                                                         @"dateCreated": @"created",
                                                         @"dateUpdated": @"updated",
                                                         @"summary": @"summary",
                                                         @"title" : @"title",
                                                         @"radius" : @"radius"
                                                         }];
    
    [_lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"creator" toKeyPath:@"creator" withMapping:self.userMapping]];
    [_lootsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"coordinate" toKeyPath:@"coordinate" withMapping:self.coordinateMapping]];
    
    return _lootsMapping;
}

- (RKObjectMapping *)userMapping {
    if(_userMapping) {
        return _userMapping;
    }
    _userMapping = [RKObjectMapping mappingForClass:[User class]];
    [_userMapping addAttributeMappingsFromDictionary:@{
                                                        @"username": @"userName"
                                                        }];
    
    return _userMapping;
}

- (RKObjectMapping *)coordinateMapping {
    if(_coordinateMapping) {
        return _coordinateMapping;
    }
    _coordinateMapping = [RKObjectMapping mappingForClass:[Coordinate class]];
    [_coordinateMapping addAttributeMappingsFromDictionary:@{
                                                        @"latitude": @"latitude",
                                                        @"longitude": @"longitude",
                                                        @"location": @"location"
                                                        }];
    
    return _coordinateMapping;
}

-(RKResponseDescriptor*)lootsRD{
    if(_lootsRD) return _lootsRD;
    _lootsRD = [RKResponseDescriptor responseDescriptorWithMapping:self.lootsMapping method:RKRequestMethodGET pathPattern:LOOTS_PATH_PATTERN keyPath:@"loots" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return _lootsRD;
}

- (void)addGETMapping {
    [self.manager addResponseDescriptor:self.lootsRD];
}

@end
