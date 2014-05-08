//
//  LoginViewController.m
//  lootr
//
//  Created by Sebastian Bock on 04.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LoginViewController.h"
#import "Facade.h"
#import "ServerCallerFacadeFactory.h"
#import "UserService.h"
#import "AppDelegate.h"
#import "RootViewController.h"


@interface LoginViewController ()
@property (nonatomic, strong) UserService* userService;
@end

@implementation LoginViewController
static NSString* keyChainUserServiceName = @"ch.hsr.lootr";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTextField.leftViewImage = [UIImage imageNamed:@"loginUserFieldIcon"];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.passWordTextField.leftViewImage = [UIImage imageNamed:@"passwordUserFieldIcon"];
}


- (IBAction)loginButtonTouchUpInside:(id)sender {
    User* loginUser = [User new];
    loginUser.email = self.emailTextField.text;
    loginUser.passWord = self.passWordTextField.text;
    [self.userService loginUser:loginUser onSuccess:^(User *user) {
        NSLog(@"success");
        [self performLogin];
    } onFailure:^(NSError *error) {
       //TODO
        NSLog(@"%@", error);
    }];
}

-(void)performLogin{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    RootViewController* rootViewController = (RootViewController*) delegate.window.rootViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [self clearTextFields];
        [rootViewController presentViewController:rootViewController.tabBarViewController animated:NO completion:nil];
    }];
}

-(void)clearTextFields
{
    self.emailTextField.text = nil;
    self.passWordTextField.text = nil;
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
