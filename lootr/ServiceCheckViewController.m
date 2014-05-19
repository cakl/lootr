//
//  TempViewController.m
//  lootr
//
//  Created by Sebastian Bock on 12.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "ServiceCheckViewController.h"

@interface ServiceCheckViewController ()
@end

@implementation ServiceCheckViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.serviceCheckLabel.text = @"You must activate the iOS Location Services before you can use the app";
}

@end
