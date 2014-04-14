//
//  CreateLootForm.h
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms.h>

typedef NS_ENUM(NSInteger, Accuracy)
{
    GenderMale = 5,
    GenderFemale = 25,
    GenderOther = 50
};

@interface CreateLootForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, assign) BOOL anonymously;

@property (nonatomic, assign) Accuracy accuracy;
 
@end
