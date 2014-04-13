//
//  ServerCallerFactory.m
//  lootr
//
//  Created by Sebastian Bock on 12.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "ServerCallerFactory.h"
#import "RestKitServerCaller.h"

@implementation ServerCallerFactory

+(id <ServerCaller>)createServerCaller
{
    return [[RestKitServerCaller alloc] initWithObjectManager:[RKObjectManager sharedManager]];
}

@end
