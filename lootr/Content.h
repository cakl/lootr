//
//  Content.h
//  lootr
//
//  Created by Sebastian Bock on 09.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Content : NSObject
@property (nonatomic, strong) NSNumber* identifier;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) NSURL* thumb;
@property (nonatomic, strong) User* creator;
@property (nonatomic, strong) NSDate* created;
@end
