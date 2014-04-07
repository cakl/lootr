//
//  LootViewViewController.h
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ServerCaller.h"
#import "RestKitServerCaller.h"

@interface LootMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (instancetype)initWithServerCaller:(id <ServerCaller>)serverCaller;
@end