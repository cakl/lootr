//
//  ServerErrorHandler.m
//  lootr
//
//  Created by Sebastian Bock on 26.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "ServerErrorHandler.h"
#import "Errors.h"

@implementation ServerErrorHandler

+(NSError*)selectErrorByOperation:(RKObjectRequestOperation*)operation andError:(NSError*)error {
    if([operation.error.domain isEqualToString:RKErrorDomain]){
        NSHTTPURLResponse* urlResponse = operation.HTTPRequestOperation.response;
        if(urlResponse){
            switch (urlResponse.statusCode) {
                case 401:
                    return [Errors produceErrorWithErrorCode:unauthorizedHTTPRequestError withUnderlyingError:operation.error];
                case 403:
                    return [Errors produceErrorWithErrorCode:forbiddenHTTPRequestError withUnderlyingError:operation.error];
                case 500:
                    return [Errors produceErrorWithErrorCode:serverSideError withUnderlyingError:operation.error];
                default:
                    return [Errors produceErrorWithErrorCode:defaultServerCallerError withUnderlyingError:operation.error];
            }
        }
    } else if([operation.error.domain isEqualToString:NSURLErrorDomain]){
        if(operation.error.code == NSURLErrorNotConnectedToInternet){
            return [Errors produceErrorWithErrorCode:notConnectedToInternetError withUnderlyingError:operation.error];
        }
        return operation.error;
    }
    return [Errors produceErrorWithErrorCode:defaultServerCallerError withUnderlyingError:error];
}

@end
