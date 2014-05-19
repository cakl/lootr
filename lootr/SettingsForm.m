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
               FXFormFieldTitle: NSLocalizedString(@"settingsform.username", nil)
               },
             @{FXFormFieldKey: @"email",
               FXFormFieldType: FXFormFieldTypeLabel,
               FXFormFieldTitle: NSLocalizedString(@"settingsform.email", nil)
               }
             ];
    
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: NSLocalizedString(@"settingsform.logout", nil),
               FXFormFieldHeader: @"",
               FXFormFieldAction: @"performLogout", @"textLabel.color": [UIColor redColor]
               },
             ];
}

@end
