//
//  ServerCallerFacade.h
//  lootr
//
//  Created by Sebastian Bock on 28.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facade.h"

@interface ServerCallerFacade : NSObject <Facade>
-(void) getLootsAtCurrentPositioninDistance:(NSNumber*)distance onSuccess:(void(^)(NSArray* loots))success onFailure:(void(^)(NSError* error))failure;
@end
