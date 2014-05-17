//
//  LoginViewController.m
//  lootr
//
//  Created by Sebastian Bock on 04.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LoginViewController.h"
#import "Facade.h"
#import "UserService.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import <SVProgressHUD.h>

@interface LoginViewController ()
@property (nonatomic, strong) UserService* userService;
@end

@implementation LoginViewController
static NSString* keyChainUserServiceName = @"ch.hsr.lootr";

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

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTextField.leftViewImage = [UIImage imageNamed:@"loginUserFieldIcon"];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.passWordTextField.leftViewImage = [UIImage imageNamed:@"passwordUserFieldIcon"];
}

#pragma mark - GUI io messages

- (IBAction)loginButtonTouchUpInside:(id)sender {
    User* loginUser = [User new];
    loginUser.email = self.emailTextField.text;
    loginUser.passWord = self.passWordTextField.text;
    [self loginUser:loginUser];
}

#pragma mark - GUI helper

-(void)clearTextFields
{
    self.emailTextField.text = nil;
    self.passWordTextField.text = nil;
}

-(void)performLogin{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    RootViewController* rootViewController = (RootViewController*) delegate.window.rootViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [self clearTextFields];
        [rootViewController checkLocationServiceAuthorization];
    }];
}

#pragma mark - interact with User Service

-(void)loginUser:(User*)user{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.userService loginUser:user onSuccess:^(User *user) {
        NSLog(@"success");
        [SVProgressHUD dismiss];
        [self performLogin];
    } onFailure:^(NSError *error) {
        //TODO
        [SVProgressHUD showErrorWithStatus:@"Login failed"];
        NSLog(@"%@", error);
    }];
}


@end
