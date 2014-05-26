//
//  ServerErrorHandler.h
//  lootr
//
//  Created by Sebastian Bock on 26.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerErrorHandler : NSObject
+(NSError*)selectErrorByOperation:(RKObjectRequestOperation*)operation andError:(NSError*)error;

@end
