//
//  Errors.m
//  lootr
//
//  Created by Sebastian Bock on 21.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "Errors.h"

NSString * const errorDomain = @"ch.hsr.lootr";

@implementation Errors

+(NSError*) produceErrorWithErrorCode:(int)ErrorCode withUnderlyingError:(NSError*)underlyingError{
    NSDictionary *userInfo;
    if(underlyingError) {
        userInfo = @{
            NSLocalizedDescriptionKey:ERROR_DESCRIPTION(ErrorCode),
            NSUnderlyingErrorKey:underlyingError
        };
    } else {
        userInfo = @{
            NSLocalizedDescriptionKey:ERROR_DESCRIPTION(ErrorCode)
        };
    }
    NSError* nError = [NSError errorWithDomain:errorDomain code:ErrorCode userInfo:userInfo];
    return nError;
}

@end
