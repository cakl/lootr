//
//  LootListViewController.h
//  lootr
//
//  Created by Sebastian Bock on 30.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ServerCaller.h"

@interface LootListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) MKUserLocation* userLocation;
@end
