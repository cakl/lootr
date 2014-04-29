//
//  CoreLocationDelegate.h
//  lootr
//
//  Created by Sebastian Bock on 29.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CoreLocationDelegate : NSObject <CLLocationManagerDelegate>
+(CoreLocationDelegate*)sharedInstance;
-(BOOL)startUpdatingLocationWithError:(NSError**)error;
-(BOOL)stopUpdatingLocationWithError:(NSError**)error;
-(CLLocation*)getCurrentLocationWithError:(NSError**)error;
@end
