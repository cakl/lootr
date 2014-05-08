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
static NSString* keyChainUserServiceName = @"ch.hsr.lootr";

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.settingsForm = [[SettingsForm alloc] init];
        self.formController.form = self.settingsForm;
    }
    return self;
}

-(void)setFormData:(SettingsForm*)settingsForm
{
    NSError* error = nil;
    User* user = [self.userService getLoggedInUserWithError:&error];
    if(!error){
        self.settingsForm.userName = user.userName;
        self.settingsForm.email = user.email;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"SettingsTabIconActive"];
    self.title = @"Settings";
    [self setFormData:self.settingsForm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)performLogout{
    NSLog(@"logout");
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    RootViewController* rootViewController = (RootViewController*) delegate.window.rootViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [rootViewController presentViewController:rootViewController.loginViewController animated:NO completion:nil];
        [self.userService deleteLoggedInUser];
    }];
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
