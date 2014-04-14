//
//  CreateLootForm.h
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms.h>

typedef NS_ENUM(NSInteger, Gender)
{
    GenderMale = 0,
    GenderFemale,
    GenderOther
};


typedef NS_OPTIONS(NSInteger, Interests)
{
    InterestComputers = 1 << 0,
    InterestSocializing = 1 << 1,
    InterestSports = 1 << 2
};

@interface CreateLootForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *repeatPassword;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, strong) UIImage *profilePhoto;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSArray *interests;
@property (nonatomic, assign) Interests otherInterests;
@property (nonatomic, copy) NSString *about;

@property (nonatomic, copy) NSString *notifications;

@property (nonatomic, assign) BOOL agreedToTerms;
 
@end
