//
//  LoginViewController.m
//  lootr
//
//  Created by Sebastian Bock on 04.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userNameTextField.leftViewImage = [UIImage imageNamed:@"loginUserFieldIcon"];
    self.userNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.userNameTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.passWordTextField.leftViewImage = [UIImage imageNamed:@"passwordUserFieldIcon"];
}

@end
