//
//  ServerCallerFacadeFactory.h
//  lootr
//
//  Created by Sebastian Bock on 30.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facade.h"

@interface ServerCallerFacadeFactory : NSObject
+(id <Facade>)createFacade;
@end
