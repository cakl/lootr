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

@interface RootViewController : UIViewController
@property (nonatomic, strong) LoginViewController* loginViewController;
@property (nonatomic, strong) TabBarViewController* tabBarViewController;
@property (nonatomic, strong) ServiceCheckViewController* serviceCheckViewController;
-(void)presentLogin;
-(void)checkLocationServiceAuthorization;
@end
