//
//  User.h
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* passWord;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* token;

@end
