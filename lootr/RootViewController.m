//
//  RootViewController.m
//  lootr
//
//  Created by Sebastian Bock on 07.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) UserService* userService;
@property (nonatomic, strong) LocationService* locationService;
@end

@implementation RootViewController

static NSString* keyChainUserServiceName = @"ch.hsr.lootr";

#pragma mark - Initialization

-(LoginViewController*)loginViewController {
    if(_loginViewController) return _loginViewController;
    _loginViewController = (LoginViewController*) [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    return _loginViewController;
}

-(TabBarViewController*)tabBarViewController {
    if(_tabBarViewController) return _tabBarViewController;
    _tabBarViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarViewController"];
    return _tabBarViewController;
}

-(ServiceCheckViewController*)serviceCheckViewController {
    if(_serviceCheckViewController) return _serviceCheckViewController;
    _serviceCheckViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"serviceCheckViewController"];
    return _serviceCheckViewController;
}

-(LocationService*)locationService {
    if(_locationService == nil) {
        _locationService = [[LocationService alloc] init];
    }
    return _locationService;
}

-(UserService*)userService {
    if(_userService == nil) {
        _userService = [[UserService alloc] initWithKeyChainServiceName:keyChainUserServiceName userDefaults:[NSUserDefaults standardUserDefaults]];
    }
    return _userService;
}

-(instancetype)initWithUserService:(UserService*)userService locationService:(LocationService*)locationService {
    self = [super init];
    if(self) {
        self.userService = userService;
        self.locationService = locationService;
    }
    return self;
}

#pragma mark - Login startup handling

-(void)presentLogin {
    NSError* error = nil;
    User* loggedInUser = [self.userService getLoggedInUserWithError:&error];
    if(!error) {
        [self checkLocationServiceAuthorization];
    } else {
        if(self.presentedViewController != self.loginViewController) {
            [self presentViewController:self.loginViewController animated:NO completion:nil];
        }
    }
}

-(void)checkLocationServiceAuthorization {
    if((![self.locationService isLocationServiceAuthorized]) && (self.presentedViewController != nil)) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self presentViewController:self.serviceCheckViewController animated:NO completion:^{
                [self.locationService startLocationService];
            }];
        }];
    }
    if([self.locationService isLocationServiceAuthorized] && (self.presentedViewController != nil) ) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self presentViewController:self.tabBarViewController animated:NO completion:^{
                [self.locationService startLocationService];
            }];
        }];
    }
    if((![self.locationService isLocationServiceAuthorized]) && (self.presentedViewController == nil) ) {
        [self presentViewController:self.serviceCheckViewController animated:NO completion:^{
            [self.locationService startLocationService];
        }];
    }
    if([self.locationService isLocationServiceAuthorized] && (self.presentedViewController == nil) ) {
        [self presentViewController:self.tabBarViewController animated:NO completion:^{
            [self.locationService startLocationService];
        }];
    }
}

@end
