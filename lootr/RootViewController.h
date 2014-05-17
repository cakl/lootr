//
//  RootViewController.h
//  lootr
//
//  Created by Sebastian Bock on 07.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "ServiceCheckViewController.h"
#import "LocationService.h"
#import "UserService.h"

@interface RootViewController : UIViewController
@property (nonatomic, strong) LoginViewController* loginViewController;
@property (nonatomic, strong) TabBarViewController* tabBarViewController;
@property (nonatomic, strong) ServiceCheckViewController* serviceCheckViewController;
- (instancetype)initWithUserService:(UserService*)userService locationService:(LocationService*)locationService;
-(void)presentLogin;
-(void)checkLocationServiceAuthorization;
@end
