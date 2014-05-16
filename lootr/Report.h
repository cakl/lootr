//
//  Report.h
//  lootr
//
//  Created by Sebastian Bock on 14.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Loot.h"

@interface Report : NSObject
@property (nonatomic, strong) NSString* purpose;
@property (nonatomic, strong) NSDate* reportTime;
@property (nonatomic, strong) User* creator;
@property (nonatomic, strong) Loot* loot;
@end
