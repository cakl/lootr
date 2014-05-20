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
#import "Content.h"

typedef NS_ENUM(int, Accuracy)
{
    AccuracyNear = 5,
    AccuracyDefault = 25,
    AccuracyWide = 50
};

@interface Loot : NSObject
@property (nonatomic, strong) NSNumber* identifier;
@property (nonatomic, strong) NSDate* created;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) User* creator;
@property (nonatomic, strong) Coordinate* coord;
@property (nonatomic, strong) NSNumber* radius;
@property (nonatomic, strong) NSSet* contents;
-(void)setRadiusWithAccuracy:(Accuracy)accuracy;
-(Accuracy)getRadiusAsAccuracy;
@end
