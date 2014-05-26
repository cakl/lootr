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
#import "SVProgressHUD+Lootr.h"
#import "UIErrorHandler.h"

@interface LoginViewController ()
@property (nonatomic, strong) UserService* userService;

@end

@implementation LoginViewController

static NSString *const loginTextFieldIconName = @"LoginUserFieldIcon";
static NSString *const passwortTextFieldIconName = @"PasswordUserFieldIcon";
static NSString *const registerURL = @"http://lootrapp.com/registerWebView.html";

#pragma mark - Initialization

-(UserService*)userService {
    if(_userService == nil) {
        _userService = [[UserService alloc] initWithKeyChainServiceName:keychainUserServiceName userDefaults:[NSUserDefaults standardUserDefaults]];
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

#pragma mark - UIViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.emailTextField.leftViewImage = [UIImage imageNamed:loginTextFieldIconName];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.passwordTextField.leftViewImage = [UIImage imageNamed:passwortTextFieldIconName];
    [self.loginButton setTitle:NSLocalizedString(@"loginviewcontroller.loginbutton.title", nil) forState:UIControlStateNormal];
    self.emailTextField.placeholder = NSLocalizedString(@"loginviewcontroller.emailfield.placeholder", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"loginviewcontroller.passwordfield.placeholder", nil);;
}

#pragma mark - GUI io messages

-(IBAction)loginButtonTouchUpInside:(id)sender {
    User* loginUser = [User new];
    loginUser.email = self.emailTextField.text;
    loginUser.passWord = self.passwordTextField.text;
    [self.view endEditing:YES];
    [self loginUser:loginUser];
}

-(IBAction)registerButtonTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:registerURL]];
}

#pragma mark - GUI helper

-(void)clearTextFields {
    self.emailTextField.text = nil;
    self.passwordTextField.text = nil;
}

-(void)performLogin {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    RootViewController* rootViewController = (RootViewController*) delegate.window.rootViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [self clearTextFields];
        [rootViewController checkLocationServiceAuthorization];
    }];
}

#pragma mark - interact with User Service

-(void)loginUser:(User*)user {
    [SVProgressHUD showApropriateHUD];
    [self.userService loginUser:user onSuccess:^(User* user) {
        [SVProgressHUD dismiss];
        [self performLogin];
    } onFailure:^(NSError* error) {
        [SVProgressHUD dismiss];
        [[UIErrorHandler generateAlertViewWithError:error delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitle:nil] show];
    }];
}

@end
