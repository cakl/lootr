//
//  CreateLootForm.m
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CreateLootForm.h"

@implementation CreateLootForm

- (NSArray *)fields
{
    return @[
             
             //we want to add a group header for the field set of fields
             //we do that by adding the header key to the first field in the group
             
             @{FXFormFieldKey: @"email", FXFormFieldHeader: @"Account"},
             
             //we don't need to modify these fields at all, so we'll
             //just refer to them by name to use the default settings
             
             @"password",
             @"repeatPassword",
             
             //we want to add another group header here, and modify the auto-capitalization
             
             @{FXFormFieldKey: @"name", FXFormFieldHeader: @"Details",
               @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)},
             
             //this is a multiple choice field, so we'll need to provide some options
             //because this is an enum property, the indexes of the options should match enum values
             
             @{FXFormFieldKey: @"gender", FXFormFieldOptions: @[@"Male", @"Female", @"It's Complicated"], FXFormFieldInline :@YES},
             
             //another regular field
             
             @"dateOfBirth",
             
             //we want to use a stepper control for this value, so let's specify that
             
             @{FXFormFieldKey: @"age", FXFormFieldCell: [FXFormStepperCell class]},
             
             //another regular field
             
             @"profilePhoto",
             
             // this is a option field that uses a FXFormOptionPickerCell to display the available
             // options in a UIPickerView
             
             @{FXFormFieldKey: @"language",
               FXFormFieldOptions: @[@"English", @"Spanish", @"French", @"Dutch"],
               FXFormFieldPlaceholder: @"None",
               FXFormFieldCell: [FXFormOptionPickerCell class]},
             
             //this is a multi-select options field - FXForms knows this because the
             //class of the field property is a collection (in this case, NSArray)
             
             @{FXFormFieldKey: @"interests", FXFormFieldPlaceholder: @"None", FXFormFieldOptions: @[@"Videogames", @"Animals", @"Cooking"]},
             
             //this is another multi-select options field, but in this case it's represented
             //as a bitfield. FXForms can't infer this from the property (which is just an integer), so
             //we explicitly specify the type as FXFormFieldTypeBitfield
             
             @{FXFormFieldKey: @"otherInterests",
               FXFormFieldType: FXFormFieldTypeBitfield,
               FXFormFieldPlaceholder: @"None",
               FXFormFieldOptions: @[@"Computers", @"Socializing", @"Sports"]},
             
             //this is a multiline text view that grows to fit its contents
             
             @{FXFormFieldKey: @"about", FXFormFieldType: FXFormFieldTypeLongText},
             
             //we want to add a section header here, so we use another config dictionary
             
             @{FXFormFieldKey: @"termsAndConditions", FXFormFieldHeader: @"Legal"},
             
             //another regular field. note that we haven't actually instantiated the terms
             //and conditions or privacy policy view controllers - FXForms will instantiate
             //view controllers automatically if the value is nil, or will used the supplied
             //controller instance if there is one
             
             @"privacyPolicy"
             
             ];
}

@end
