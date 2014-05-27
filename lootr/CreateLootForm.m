//
//  CreateLootForm.m
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CreateLootForm.h"

@implementation CreateLootForm

-(NSArray*)fields {
    return @[
             //@"title",
             @{FXFormFieldKey: @"title",
               FXFormFieldTitle: NSLocalizedString(@"createlootform.title", nil)
               },
             @{FXFormFieldKey: @"summary",
               FXFormFieldType: FXFormFieldTypeLongText,
               FXFormFieldFooter: NSLocalizedString(@"createlootform.summary.footer", nil),
               FXFormFieldTitle: NSLocalizedString(@"createlootform.summary.title", nil)
               },
             @{FXFormFieldKey: @"accuracy",
               FXFormFieldHeader: NSLocalizedString(@"createlootform.accuracy.formheader", nil),
               FXFormFieldOptions: @[@(AccuracyNear), @(AccuracyDefault), @(AccuracyWide)],
               FXFormFieldInline :@YES , FXFormFieldFooter: NSLocalizedString(@"createlootform.accuracy.footer", nil),
               FXFormFieldValueTransformer: ^(id input){
                    return @{@(AccuracyNear): NSLocalizedString(@"createlootform.accuracy.accuracyneartext", nil), @(AccuracyDefault): NSLocalizedString(@"createlootform.accuracy.accuracydefaulttext", nil), @(AccuracyWide): NSLocalizedString(@"createlootform.accuracy.accuracywidetext", nil)}[input];
                }
               }
             ];
}

@end
