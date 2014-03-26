//
//  Loot.h
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Coordinate.h"

@interface Loot : NSObject
@property (nonatomic, strong) NSNumber* identifier;
@property (nonatomic, strong) NSDate* created;
@property (nonatomic, strong) NSDate* updated;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) User* creator;
@property (nonatomic, strong) Coordinate* coordinate;
@property (nonatomic, strong) NSNumber* radius;
@end
