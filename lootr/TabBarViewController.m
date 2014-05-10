//
//  TabBarControllerViewController.m
//  lootr
//
//  Created by Sebastian Bock on 07.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

-(void)viewWillAppear:(BOOL)animated{
    // iOS 7.1 BUGFIX TABBAR: http://stackoverflow.com/questions/22327646/tab-bar-background-is-missing-on-ios-7-1-after-presenting-and-dismissing-a-view
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBar.translucent = NO;
        self.tabBar.translucent = YES;
    });
    self.selectedIndex = 0;
}
@end
