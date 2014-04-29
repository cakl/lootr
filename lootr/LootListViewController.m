//
//  LootListViewController.m
//  lootr
//
//  Created by Sebastian Bock on 30.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootListViewController.h"
#import "ServerCallerFactory.h"
#import "Loot.h"
#import "Facade.h"
#import "ServerCallerFacade.h"

@interface LootListViewController ()
//@property (nonatomic, strong) id <ServerCaller> serverCaller;
@property (nonatomic, strong) NSArray* loots;
@property (nonatomic, strong) id<Facade> facade;
@end

@implementation LootListViewController
static const NSUInteger limitedCount = 10;
static NSString *cellIdentifier = @"DetailCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"ListTabIcon"];
    [self loadLootsAtCurrentPosition];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"Loots";
}

-(id <Facade>)facade{
    if(_facade == nil)
    {
        _facade = [[ServerCallerFacade alloc] init];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.loots count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Loot* loot = [self.loots objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = loot.title;
    cell.detailTextLabel.text = @"< XXm ";
    
    return cell;
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
