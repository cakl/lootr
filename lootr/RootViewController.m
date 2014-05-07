//
//  RootViewController.m
//  lootr
//
//  Created by Sebastian Bock on 07.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "UserService.h"

@interface RootViewController ()
@property (nonatomic, strong) UserService* userService;
@end

@implementation RootViewController
static NSString* keyChainUserServiceName = @"ch.hsr.lootr";

-(LoginViewController*)loginViewController{
    if(_loginViewController) return _loginViewController;
    _loginViewController = (LoginViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    return _loginViewController;
}

-(TabBarViewController*)tabBarViewController{
    if(_tabBarViewController) return _tabBarViewController;
    _tabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarViewController"];
    return _tabBarViewController;
}

-(void)presentLogin{
    NSError* error = nil;
    User* loggedInUser = [self.userService getLoggedInUserWithError:&error];
    if(!error){
        [self presentViewController:self.tabBarViewController animated:NO completion:nil];
    } else {
        [self presentViewController:self.loginViewController animated:NO completion:nil];
    }
}

#pragma mark - Initialization

-(UserService*)userService{
    if(_userService == nil)
    {
        _userService = [[UserService alloc] initWithKeyChainServiceName:keyChainUserServiceName userDefaults:[NSUserDefaults standardUserDefaults]];
    }
    return _userService;
}

- (instancetype)initWithUserService:(UserService*)userService
{
    self = [super init];
    if (self) {
        self.userService = userService;
    }
    return self;
}

@end
