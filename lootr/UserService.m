//
//  UserService.m
//  lootr
//
//  Created by Sebastian Bock on 05.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "UserService.h"
#import "ServerCallerFactory.h"
#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>

@interface UserService ()
@property (nonatomic, strong) id<ServerCaller> serverCaller;
@end

@implementation UserService
static NSString *const userDefaultsUserNameKey = @"username";
static NSString *const userDefaultsEmailKey = @"email";
static NSString *const AFNetworkingAuthorizationHeaderKey = @"Authorization";

-(id <ServerCaller>)serverCaller{
    if (_serverCaller == nil)
    {
        _serverCaller = [ServerCallerFactory createServerCaller];
    }
    return _serverCaller;
}

- (instancetype)initWithKeyChainServiceName:(NSString*)serviceName userDefaults:(NSUserDefaults*)userDefaults
{
    return [self initWithKeyChainServiceName:serviceName userDefaults:userDefaults serverCaller:nil];
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
    if(user.token && user.userName){
        [SSKeychain setPassword:user.token forService:self.keyChainServiceName account:user.userName error:error];
        if(!(*error)){
            user.passWord = nil;
            [self.userDefaults setObject:user.userName forKey:userDefaultsUserNameKey];
            [self.userDefaults setObject:user.email forKey:userDefaultsEmailKey];
            return YES;
        }
    }
    *error = [NSError errorWithDomain:@"ch.hsr.lootr" code:1000 userInfo:nil];
    return NO;
}

-(User*)getLoggedInUserWithError:(NSError**)error{
    NSString* userName = [self.userDefaults objectForKey:userDefaultsUserNameKey];
    NSString* email = [self.userDefaults objectForKey:userDefaultsEmailKey];
    if(userName){
        User* loggedInUser = [User new];
        loggedInUser.userName = userName;
        loggedInUser.email = email;
        loggedInUser.token = [self getPasswordForUsername:loggedInUser.userName error:error];
        if(!*error){
            [self setAuthorizationToken:loggedInUser.token]; //TODO: write unit test for this case! kill simu. restart already loggedin token set?
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
    [self.userDefaults removeObjectForKey:userDefaultsUserNameKey];
    [self.userDefaults removeObjectForKey:userDefaultsEmailKey];
    [self clearKeyChain];
}

-(void)setAuthorizationToken:(NSString*)token
{
    [self.serverCaller setAuthorizationToken:token];
    [[SDWebImageManager.sharedManager imageDownloader] setValue:[NSString stringWithFormat:@"Token token=\"%@\"", token] forHTTPHeaderField:AFNetworkingAuthorizationHeaderKey];
}

-(void)clearAuthorizationToken
{
    [self.serverCaller clearAuthorizationToken];
    [[SDWebImageManager.sharedManager imageDownloader] setValue:@"" forHTTPHeaderField:AFNetworkingAuthorizationHeaderKey];
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
