//
//  CreateLootViewController.m
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CreateLootViewController.h"
#import "CreateLootForm.h"

@interface CreateLootViewController ()
@end

@implementation CreateLootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.formController.form = [[CreateLootForm alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.formController = [[FXFormViewController alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
