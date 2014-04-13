//
//  LootContentViewController.h
//  lootr
//
//  Created by Sebastian Bock on 09.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RPSlidingMenuViewController.h"
#import "Loot.h"

@interface LootContentViewController : RPSlidingMenuViewController <UIActionSheetDelegate>
@property (nonatomic, strong) Loot* loot;
@property (nonatomic, strong) NSArray* lootsContents;
@end
