//
//  CreateLootViewController.m
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CreateLootViewController.h"
#import "CreateLootForm.h"
#import "ServerCaller.h"
#import "ServerCallerFactory.h"
#import "Loot.h"
#import "User.h"

@interface CreateLootViewController ()
@property(strong) UINavigationBar *navigationBar;
@property(nonatomic, strong) id<ServerCaller> serverCaller;
@end

@implementation CreateLootViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.formController.form = [[CreateLootForm alloc] init];
    }
    return self;
}

- (id<ServerCaller>)serverCaller {
    if (_serverCaller == nil) {
        _serverCaller = [ServerCallerFactory createServerCaller];
    }
    return _serverCaller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"New Loot";
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(cancelButtonPressed)];
    UIBarButtonItem *createButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Create"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(createButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = createButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)cancelButtonPressed {
    [self dismissSelfViewController];
}

- (void)createButtonPressed {
    [self.view endEditing:YES];
    CreateLootForm *createLootForm = self.formController.form;
    if ([createLootForm.title length] == 0 || [createLootForm.summary length] == 0 || createLootForm.accuracy == 0 ) {
        [[[UIAlertView alloc] initWithTitle:@"please check data"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    } else {
        Loot *postLoot = [Loot new];
        postLoot.title = createLootForm.title;
        postLoot.summary = createLootForm.summary;
        [postLoot setRadiusWithAccuracy:createLootForm.accuracy];
        Coordinate *userLocation = [[Coordinate alloc] initWithCoordinate2D:self.userLocation.coordinate];
        postLoot.coord = userLocation;
        User *user = [User new];
        user.userName = @"Mario";
        postLoot.creator = user;
        [self postLoot:postLoot];
    }
}

- (void)postLoot:(Loot *)loot {
    [self.serverCaller postLoot:loot onSuccess:^(Loot *loot) {
        NSLog(@"%@", loot);
        [self dismissSelfViewController];
    }
    onFailure:^(NSError *error) { NSLog(@"%@", error); }];
}

-(void)dismissSelfViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
