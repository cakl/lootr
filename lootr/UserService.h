//
//  UserService.h
//  lootr
//
//  Created by Sebastian Bock on 05.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSKeychain.h>
#import <SSKeychainQuery.h>
#import "ServerCaller.h"
#import "User.h"

@interface UserService : NSObject
@property (nonatomic, strong, readonly) NSString* keyChainServiceName;
@property (nonatomic, strong, readonly) NSUserDefaults* userDefaults;
- (instancetype)initWithKeyChainServiceName:(NSString*)serviceName userDefaults:(NSUserDefaults*)userDefaults;
- (instancetype)initWithKeyChainServiceName:(NSString*)serviceName userDefaults:(NSUserDefaults*)userDefaults serverCaller:(id<ServerCaller>)serverCaller;
-(BOOL)setLoggedInUser:(User*)user error:(NSError**)error;
-(User*)getLoggedInUserWithError:(NSError**)error;
-(void)deleteLoggedInUser;
-(void)loginUser:(User*)user onSuccess:(void(^)(User* user))success onFailure:(void(^)(NSError* error))failure;
-(void)logoutUser:(User*)user;
@end
