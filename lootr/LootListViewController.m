//
//  LootListViewController.m
//  lootr
//
//  Created by Sebastian Bock on 30.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootListViewController.h"
#import "Loot.h"
#import "Facade.h"
#import "ServerCallerFacadeFactory.h"
#import "LocationService.h"
#import "LootContentViewController.h"

@interface LootListViewController ()
@property (nonatomic, strong) NSArray* loots;
@property (nonatomic, strong) id<Facade> facade;
@property (nonatomic, strong) LocationService* locationService;
@property (nonatomic, strong) Loot* lastSelectedLoot;
@end

@implementation LootListViewController
static NSUInteger const limitedCount = 10;
static NSString *const cellIdentifier = @"DetailCell";
static NSString *const tabBarImageIconName = @"ListTabIcon";
static NSString *const showLootSegueIdentifier = @"showLoot";

#pragma mark - Initialization

-(id <Facade>)facade{
    if(_facade == nil)
    {
        _facade = [ServerCallerFacadeFactory createFacade];
    }
    return _facade;
}

-(LocationService*)locationService{
    if(_locationService == nil)
    {
        _locationService = [[LocationService alloc] init];
    }
    return _locationService;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem.selectedImage = [UIImage imageNamed:tabBarImageIconName];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = NSLocalizedString(@"lootlistviewcontroller.title", nil);
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.delegate = self;
    [self.tableView reloadData];
    [self loadLootsAtCurrentPosition];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self loadLootsAtCurrentPosition];
    [refreshControl endRefreshing];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:showLootSegueIdentifier]){
        LootContentViewController* contentViewController = segue.destinationViewController;
        contentViewController.loot = self.lastSelectedLoot;
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.loots count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Loot* loot = [self.loots objectAtIndex:indexPath.row];
    DistanceTreshold distanceThreshold = [self.locationService getDistanceThresholdfromCurrentLocationToLoot:loot];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = loot.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"< %im", distanceThreshold];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastSelectedLoot = [self.loots objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:showLootSegueIdentifier sender:self];
}

#pragma mark - UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController != self.navigationController){
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    return YES;
}

#pragma mark - Loading Data from Server

-(void)loadLootsAtCurrentPosition{
    [self.facade getLootsAtCurrentPositionWithLimitedCount:limitedCount onSuccess:^(NSArray *loots) {
        self.loots = loots;
        [self.tableView reloadData];
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
