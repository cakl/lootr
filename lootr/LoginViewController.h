//
//  LoginViewController.h
//  lootr
//
//  Created by Sebastian Bock on 04.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView.h>
#import "LoginTextField.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet LoginTextField *emailTextField;
@property (weak, nonatomic) IBOutlet LoginTextField *passWordTextField;
@end
