//
//  CreateLootForm.h
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms.h>
#import "Loot.h"


@interface CreateLootForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, assign) Accuracy accuracy;
 
@end
