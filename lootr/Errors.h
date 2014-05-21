//
//  Errors.h
//  lootr
//
//  Created by Sebastian Bock on 21.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FORMAT_ERROR_DESCRIPTION(code) [NSString stringWithFormat:@"%d_d", code]
#define FORMAT_RECOVERY_SUGGESTION(code) [NSString stringWithFormat:@"%d_rs", code]
#define FORMAT_FAILURE_REASON(code) [NSString stringWithFormat:@"%d_fr", code]
#define ERROR_DESCRIPTION(code)  NSLocalizedStringFromTable(FORMAT_ERROR_DESCRIPTION(code), @"Errors", nil)
#define ERROR_RECOVERY_SUGGESTION(code)  NSLocalizedStringFromTable(FORMAT_RECOVERY_SUGGESTION(code), @"Errors", nil)
#define ERROR_FAILURE_REASON(code)  NSLocalizedStringFromTable(FORMAT_FAILURE_REASON(code), @"Errors", nil)

extern NSString * const errorDomain;

enum {
    userServiceInvalidArgumentError = 1000,
    userServiceUserRecoveryError = 1001
};

@interface Errors : NSObject

+(NSError*) produceErrorWithErrorCode:(int)ErrorCode withUnderlyingError:(NSError*)underlyingError;

@end
