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
- (instancetype)initWithLocationManager:(CLLocationManager*)locationManager geocoder:(CLGeocoder*)geocoder;
-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;
-(CLLocation*)getCurrentLocationWithError:(NSError**)error;
-(NSString*)getCurrentCityWithError:(NSError**)error;
-(BOOL)isAuthorized;
@end
