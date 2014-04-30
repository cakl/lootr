//
//  Coordinate.h
//  lootr
//
//  Created by Sebastian Bock on 24.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Coordinate : NSObject
@property (nonatomic, strong) NSNumber* latitude;
@property (nonatomic, strong) NSNumber* longitude;
@property (nonatomic, strong) NSString* location;
- (instancetype)initWithCoordinate2D:(CLLocationCoordinate2D)coordinate;
-(CLLocation*)asCLLocation;
@end
