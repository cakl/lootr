//
//  UserServiceTest.m
//  lootr
//
//  Created by Sebastian Bock on 05.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserService.h"
#import <SSKeychain.h>
#import "User.h"
#import "Errors.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface UserServiceTest : XCTestCase
@property (nonatomic, strong) UserService* userService;
@property (nonatomic, strong) NSUserDefaults* userDefaults;
@end

@implementation UserServiceTest
static NSString* const keyChainServiceName = @"lootrKeyChainTest";
static NSString* const userDefaultsSuiteName = @"testUserDefaults";

//TODO: describe in SAD why I'm using white tests: Keychain access is static and so its not easy mockable. best way is a white system test in my opinion. test exactly the functionality used in upper layers.
//TODO: Error handling in UserService and test this error handling

- (void)setUp
{
    [super setUp];
    self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:userDefaultsSuiteName];
    self.userService = [[UserService alloc] initWithKeyChainServiceName:keyChainServiceName userDefaults:self.userDefaults];
}

- (void)tearDown
{
    [self resetUserDefaults];
    [self resetKeyChain:keyChainServiceName];
    [super tearDown];
}

-(void)resetUserDefaults
{
    [self.userDefaults removeObjectForKey:@"username"];
    [self.userDefaults removeObjectForKey:@"email"];
}

-(void)resetKeyChain:(NSString*)keyChainServiceName
{
    NSArray* accounts = [SSKeychain allAccounts];
    [accounts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* account = [obj objectForKey:@"acct"];
        [SSKeychain deletePasswordForService:keyChainServiceName account:account];
    }];
}

- (void)testSetLoggedInUserSuccess
{
    //given
    User* mario = [User new];
    mario.userName = @"mario";
    mario.token = @"234324nj23n4b23j4b213j4bjbh213v4";
    NSError* error = nil;
    //when
    BOOL returnValue = [self.userService setLoggedInUser:mario error:&error];
    //then
    XCTAssertTrue(returnValue, @"set logged in user failed");
}

- (void)testSetLoggedInUserWithNoUsernameAndNoPasswortFail
{
    //given
    User* mario = [User new];
    NSError* error = nil;
    //when
    BOOL returnValue = [self.userService setLoggedInUser:mario error:&error];
    //then
    XCTAssertNotNil(error, @"should return an error");
    XCTAssertTrue(([error code] == userServiceInvalidArgumentError), @"retuning wrong error code");
    XCTAssertFalse(returnValue, @"set empty user succeeded");
}

-(void)testGetLoggedInUserWithNoUserSetFail
{
    NSError* error = nil;
    User* nilUser = [self.userService getLoggedInUserWithError:&error];
    XCTAssertNotNil(error, @"No Error thrown while no user exists");
    XCTAssertNil(nilUser, @"user should be nil");
    XCTAssertTrue(([error code] == userServiceUserRecoveryError), @"retuning wrong error code");
}

//-(void)testDeleteLoggedInUser{
//    //given
//    User* mario = [User new];
//    mario.userName = @"mario";
//    mario.token = @"234324nj23n4b23j4b213j4bjbh213v4";
//    NSError* error1 = nil;
//    [self.userService setLoggedInUser:mario error:&error1];
//    if(error1) XCTFail(@"failed saving user");
//    //when
//    NSError* error = nil;
//    [self.userService deleteLoggedInUser];
//    //then
//    XCTAssertNil(error, @"error occured deleting user");
//    XCTAssertEqual([[SSKeychain allAccounts] count], 0, @"deleting keychain failed");
//    XCTAssertNil([self.userDefaults objectForKey:@"username"], @"deleting username in userdefaults failed");
//}

-(void)testSetAndGetUserSuccess
{
    //given
    User* mario = [User new];
    mario.userName = @"mario";
    mario.token = @"234324nj23n4b23j4b213j4bjbh213v4";
    NSError* setError = nil;
    NSError* getError = nil;
    //when
    [self.userService setLoggedInUser:mario error:&setError];
    User* gotMario = [self.userService getLoggedInUserWithError:&getError];
    //then
    XCTAssertEqual(gotMario.userName, @"mario", @"different usernames");
    XCTAssertTrue([gotMario.userName isEqualToString:@"mario"], @"different usernames");
    XCTAssertTrue([gotMario.token isEqualToString:@"234324nj23n4b23j4b213j4bjbh213v4"], @"different tokens");
}

-(void)testAuthorizationHeaderSetAndGetSuccess
{
    static NSString *const keyChainServiceName = @"temporaryKeyChain";
    //given
    id<ServerCaller> serverCaller = mockProtocol(@protocol(ServerCaller));
    UserService* aUserService = [[UserService alloc] initWithKeyChainServiceName:keyChainServiceName userDefaults:self.userDefaults serverCaller:serverCaller];
    
    User* mario = [User new];
    mario.userName = @"mario";
    mario.token = @"234324nj23n4b23j4b213j4bjbh213v4";
    NSError* setError = nil;
    NSError* getError = nil;
    //when
    [aUserService setLoggedInUser:mario error:&setError];
    [aUserService getLoggedInUserWithError:&getError];
    //then
    [verify(serverCaller) setAuthorizationToken:mario.token];
    [self resetKeyChain:keyChainServiceName];
}


@end
