//
//  CreateLootViewController.m
//  lootr
//
//  Created by Sebastian Bock on 14.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "CreateLootViewController.h"
#import "CreateLootForm.h"
#import "Facade.h"
#import "ServerCallerFacadeFactory.h"
#import <SVProgressHUD.h>

@interface CreateLootViewController ()
@property(strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) id<Facade> facade;
@property (nonatomic, strong) UIActivityIndicatorView *aSpinner;
@end

@implementation CreateLootViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.formController.form = [[CreateLootForm alloc] init];
    }
    return self;
}

-(id <Facade>)facade{
    if(_facade == nil)
    {
        _facade = [ServerCallerFacadeFactory createFacade];
    }
    return _facade;
}

- (instancetype)initWithFacade:(id <Facade>)facade
{
    self = [super init];
    if (self) {
        self.facade = facade;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"createlootviewcontroller.title", nil);
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(cancelButtonPressed)];
    UIBarButtonItem *createButton =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"createlootviewcontroller.createbutton.title", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(createButtonPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = createButton;
}

-(void)dismissSelfViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - User Interaction

- (void)cancelButtonPressed {
    [self dismissSelfViewController];
}

- (void)createButtonPressed {
    [self.view endEditing:YES];
    CreateLootForm *createLootForm = self.formController.form;
    if ([createLootForm.title length] == 0 || [createLootForm.summary length] == 0 || createLootForm.accuracy == 0 ) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil)
                                    message:NSLocalizedString(@"createlootviewcontroller.alert.create.message", nil)
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"ok", nil), nil] show];
    } else {
        Loot *postLoot = [self createLootFromInputForm:self.formController.form];
        [self postLoot:postLoot];
    }
}

-(Loot*)createLootFromInputForm:(CreateLootForm*)form{
    Loot *postLoot = [Loot new];
    postLoot.title = form.title;
    postLoot.summary = form.summary;
    [postLoot setRadiusWithAccuracy:form.accuracy];
    return postLoot;
}

#pragma mark - Loading Data from Server

- (void)postLoot:(Loot *)loot{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self.facade postLoot:loot atCurrentLocationOnSuccess:^(Loot *loot) {
        [self dismissSelfViewController];
        [SVProgressHUD dismiss];
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
    }];
}



@end
