//
//  UserService.m
//  lootr
//
//  Created by Sebastian Bock on 05.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "UserService.h"
#import "ServerCallerFactory.h"

@interface UserService ()
@property (nonatomic, strong) id<ServerCaller> serverCaller;
@end

@implementation UserService
static NSString* userDefaultsKey = @"username";

-(id <ServerCaller>)serverCaller{
    if (_serverCaller == nil)
    {
        _serverCaller = [ServerCallerFactory createServerCaller];
    }
    return _serverCaller;
}

- (instancetype)initWithKeyChainServiceName:(NSString*)serviceName userDefaults:(NSUserDefaults*)userDefaults
{
    self = [super init];
    if (self) {
        _keyChainServiceName = serviceName;
        _userDefaults = userDefaults;
    }
    return self;
}

- (instancetype)initWithKeyChainServiceName:(NSString*)serviceName userDefaults:(NSUserDefaults*)userDefaults serverCaller:(id<ServerCaller>)serverCaller
{
    self = [super init];
    if (self) {
        _keyChainServiceName = serviceName;
        _userDefaults = userDefaults;
        self.serverCaller = serverCaller;
    }
    return self;
}

-(BOOL)setLoggedInUser:(User*)user error:(NSError**)error{
    if(user.token || user.userName){
        [SSKeychain setPassword:user.token forService:self.keyChainServiceName account:user.userName error:error];
        if(!(*error)){
            user.passWord = nil;
            [self.userDefaults setObject:user.userName forKey:userDefaultsKey];
            return YES;
        }
    }
    *error = [NSError errorWithDomain:@"ch.hsr.lootr" code:1000 userInfo:nil];
    return NO;
}

-(User*)getLoggedInUserWithError:(NSError**)error{
    NSString* userName = [self.userDefaults objectForKey:userDefaultsKey];
    if(userName){
        User* loggedInUser = [User new];
        loggedInUser.userName = userName;
        loggedInUser.token = [self getPasswordForUsername:loggedInUser.userName error:error];
        if(!*error){
            return loggedInUser;
        }
    }
    *error = [NSError errorWithDomain:@"ch.hsr.lootr" code:1000 userInfo:nil];
    return nil;
}

-(NSString*)getPasswordForUsername:(NSString*)userName error:(NSError**)error{
    return [SSKeychain passwordForService:self.keyChainServiceName account:userName error:error];
}

-(void)clearKeyChain{
    NSArray* accounts = [SSKeychain allAccounts];
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* account = [obj objectForKey:@"acct"];
        [SSKeychain deletePasswordForService:self.keyChainServiceName account:account];
    }];
}

-(void)deleteLoggedInUser{
    [self.userDefaults removeObjectForKey:userDefaultsKey];
    [self clearKeyChain];
}

-(void)setAuthorizationToken:(NSString*)token
{
    [self.serverCaller setAuthorizationToken:token];
}

-(void)clearAuthorizationToken
{
    [self.serverCaller clearAuthorizationToken];
}

-(void)loginUser:(User*)user onSuccess:(void(^)(User* user))success onFailure:(void(^)(NSError* error))failure{
    [self.serverCaller postUser:user onSuccess:^(User *user) {
        NSError* loginError = nil;
        [self setLoggedInUser:user error:&loginError];
        if(!loginError) {
            [self setAuthorizationToken:user.token];
            success(user);
        } else {
            failure(loginError);
        }
    } onFailure:^(NSError *error) {
        failure(error);
    }];
}

-(void)logoutUser:(User*)user
{
    [self deleteLoggedInUser];
}

@end
