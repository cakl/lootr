//
//  SettingsForm.m
//  lootr
//
//  Created by Sebastian Bock on 08.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "SettingsForm.h"

@implementation SettingsForm

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"userName",
               FXFormFieldType: FXFormFieldTypeLabel,
               FXFormFieldTitle: @"Username"
               },
             @{FXFormFieldKey: @"email",
               FXFormFieldType: FXFormFieldTypeLabel,
               FXFormFieldTitle: @"Email"
               }
             ];
    
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Logout",
               FXFormFieldHeader: @"",
               FXFormFieldAction: @"performLogout", @"textLabel.color": [UIColor redColor]
               },
             ];
}

@end
