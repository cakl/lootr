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

@interface LootListViewController ()
@property (nonatomic, strong) id <ServerCaller> serverCaller;
@property (nonatomic, strong) NSArray* loots;
@end

@implementation LootListViewController
static const NSUInteger limitedCount = 10;
static NSString *cellIdentifier = @"DetailCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"ListTabIcon"];
    [self loadLootsAtCoordinate:self.userLocation.coordinate];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"Loots";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id <ServerCaller>)serverCaller{
    if (_serverCaller == nil)
    {
        _serverCaller = [ServerCallerFactory createServerCaller];
    }
    return _serverCaller;
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
-(void)loadLootsAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self.serverCaller getLootsAtLatitude:[NSNumber numberWithDouble:coordinate.latitude] andLongitude:[NSNumber numberWithDouble:coordinate.longitude] withLimitedCount:[NSNumber numberWithUnsignedInt:limitedCount] onSuccess:^(NSArray *loots) {
        self.loots = loots;
        [self.tableView reloadData];
    } onFailure:^(NSError *error) {
        NSLog(@"ERROR");
    }];
}

@end
