//
//  loginTextField.m
//  lootr
//
//  Created by Sebastian Bock on 05.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LoginTextField.h"

@implementation LoginTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.textColor = [UIColor lightGrayColor];
        self.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    return self;
}

-(void)setLeftViewImage:(UIImage *)leftViewImage{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:leftViewImage];
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect newBounds = [super placeholderRectForBounds:bounds];
    return newBounds;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect newBounds = [super textRectForBounds:bounds];
    newBounds.size.width -= 10;
    newBounds.origin.x += 10;
    return newBounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect newBounds = [super editingRectForBounds:bounds];
    newBounds.size.width -= 10;
    newBounds.origin.x += 10;
    return newBounds;
}

@end
