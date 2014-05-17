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
             @"title",
             @{FXFormFieldKey: @"summary",
               FXFormFieldType: FXFormFieldTypeLongText,
               FXFormFieldFooter: @"The description and title are public and not dependent on location. Those informations will be displayed on the web. Choose your text carefully",
               FXFormFieldTitle: @"Description"
               },
             @{FXFormFieldKey: @"accuracy",
               FXFormFieldHeader: @"Accurary",
               FXFormFieldOptions: @[@(AccuracyNear), @(AccuracyDefault), @(AccuracyWide)],
               FXFormFieldInline :@YES , FXFormFieldFooter: @"The minimum distance to the Loot for someone to see the entire contents",
               FXFormFieldValueTransformer: ^(id input){
                    return @{@(AccuracyNear): @"5 Meters", @(AccuracyDefault): @"25 Meters", @(AccuracyWide): @"50 Meters"}[input];
                }
               }
             ];
}

@end
