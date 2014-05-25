//
//  loginTextField.m
//  lootr
//
//  Created by Sebastian Bock on 05.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//
#import "LoginTextField.h"

@implementation LoginTextField

static CGFloat const margin = 10;
static UIKeyboardAppearance const keyboardAppearance = UIKeyboardAppearanceDark;

-(instancetype)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if(self) {
        self.textColor = [UIColor lightGrayColor];
        self.keyboardAppearance = keyboardAppearance;
    }
    return self;
}

-(void)setLeftViewImage:(UIImage*)leftViewImage {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:leftViewImage];
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect newBounds = [super placeholderRectForBounds:bounds];
    return newBounds;
}

-(CGRect)textRectForBounds:(CGRect)bounds {
    CGRect newBounds = [super textRectForBounds:bounds];
    return [self bounds:newBounds withMargin:margin];
}

-(CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect newBounds = [super editingRectForBounds:bounds];
    return [self bounds:newBounds withMargin:margin];
}

-(CGRect)bounds:(CGRect)bounds withMargin:(CGFloat)margin {
    bounds.size.width -= margin;
    bounds.origin.x += margin;
    return bounds;
}

@end
