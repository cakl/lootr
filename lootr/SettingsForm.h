//
//  SettingsForm.h
//  lootr
//
//  Created by Sebastian Bock on 08.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms.h>

@interface SettingsForm : NSObject <FXForm>

@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* email;

@end
