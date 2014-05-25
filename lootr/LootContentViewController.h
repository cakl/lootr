//
//  TestTableViewController.h
//  lootr
//
//  Created by Sebastian Bock on 17.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loot.h"

@interface LootContentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, strong) Loot* loot;

@end
