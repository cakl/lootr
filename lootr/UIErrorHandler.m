//
//  UIErrorHandler.m
//  lootr
//
//  Created by Sebastian Bock on 26.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "UIErrorHandler.h"

@implementation UIErrorHandler

+(UIAlertView*)generateAlertViewWithError:(NSError*)error delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil)
                                                        message:error.localizedDescription
                                                       delegate:delegate
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitle, nil];
    return alertView;
}

@end
