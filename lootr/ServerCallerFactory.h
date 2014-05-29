//
//  ServerCallerFactory.h
//  lootr
//
//  Created by Sebastian Bock on 12.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCaller.h"

@interface ServerCallerFactory : NSObject
+(id <ServerCaller>)createServerCaller;

@end
