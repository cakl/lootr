//
//  SettingsViewController.m
//  lootr
//
//  Created by Sebastian Bock on 30.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsForm.h"
#import "UserService.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@interface SettingsViewController ()
@property (nonatomic, strong) UserService* userService;
@property (nonatomic, strong) SettingsForm* settingsForm;

@end

@implementation SettingsViewController

static NSString *const keyChainUserServiceName = @"ch.hsr.lootr";
static NSString *const tabBarImageIconName = @"SettingsTabIconActive";

#pragma mark - Initialization

-(UserService*)userService {
    if(_userService == nil) {
        _userService = [[UserService alloc] initWithKeyChainServiceName:keyChainUserServiceName userDefaults:[NSUserDefaults standardUserDefaults]];
    }
    return _userService;
}

-(instancetype)initWithUserService:(UserService*)userService {
    self = [super init];
    if(self) {
        self.userService = userService;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self) {
        self.settingsForm = [[SettingsForm alloc] init];
        self.formController.form = self.settingsForm;
    }
    return self;
}

#pragma mark - UIViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.selectedImage = [UIImage imageNamed:tabBarImageIconName];
    self.title = NSLocalizedString(@"settingsviewcontroller.title", nil);
}

-(void)viewWillAppear:(BOOL)animated {
    [self setFormData:self.settingsForm];
}

#pragma mark - GUI Helper

-(void)setFormData:(SettingsForm*)settingsForm {
    NSError* error = nil;
    User* user = [self.userService getLoggedInUserWithError:&error];
    if(!error) {
        self.settingsForm.userName = user.userName;
        self.settingsForm.email = user.email;
        [self.tableView reloadData];
    }
}

#pragma mark - Loading Data from Server

-(void)performLogout {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    RootViewController* rootViewController = (RootViewController*) delegate.window.rootViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [rootViewController presentViewController:rootViewController.loginViewController animated:NO completion:nil];
        [self.userService deleteLoggedInUser];
    }];
}

@end
