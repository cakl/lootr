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
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
