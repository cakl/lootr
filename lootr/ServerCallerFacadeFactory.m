//
//  ServerCallerFacadeFactory.m
//  lootr
//
//  Created by Sebastian Bock on 30.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "ServerCallerFacadeFactory.h"
#import "ServerCallerFacade.h"

@implementation ServerCallerFacadeFactory

+(id <Facade>)createFacade {
    return [[ServerCallerFacade alloc] init];
}

@end
