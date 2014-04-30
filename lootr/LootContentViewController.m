//
//  TestTableViewController.m
//  lootr
//
//  Created by Sebastian Bock on 17.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootContentViewController.h"
#import "ImageViewTableViewCell.h"
#import <JCRBlurView.h>
#import <UIImageView+WebCache.h>
#import <FXBlurView.h>
#import <QuartzCore/QuartzCore.h>
#import <UIImageView+WebCache.h>
#import <TGRImageViewController.h>
#import <TGRImageZoomAnimationController.h>
#import "Facade.h"
#import "ServerCallerFacade.h"
#import "LocationService.h"

@interface LootContentViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSArray* lootContents;
@property (nonatomic, strong) UIImageView* lastDownloadedImage;
@property (nonatomic, strong) id<Facade> facade;
@property (nonatomic, strong) LocationService* locationService;
@property (nonatomic, strong) UILabel* distanceToLootLabel;
@end

@implementation LootContentViewController
static NSString *CellIdentifierDetailed = @"ImageCell";

#pragma mark - Initialization

-(id <Facade>)facade{
    if(_facade == nil)
    {
        _facade = [[ServerCallerFacade alloc] init];
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 90, 0); //TODO should be dynamic on 4, 3.5 screens
    self.title = self.loot.title;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonPressed)];
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    self.lastDownloadedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage"]];
    self.lastDownloadedImage.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self reloadLootWithContents];
}

#pragma mark - GUI io messages

- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self reloadLootWithContents];
    [self setDistanceToLootLabelText];
    [refreshControl endRefreshing];
}

-(void)infoButtonPressed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)reportButtonPressed
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)addBarButtonPressed
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", @"Write Text", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.loot.contents count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Content* content = [self.lootContents objectAtIndex:indexPath.row];
    
    ImageViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDetailed];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell.fullImageView setImageWithURL:content.thumb completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [cell.blurFooterView setNeedsDisplay];
    }];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    
    NSString* dateString = [dateFormatter stringFromDate:content.created];
    
    cell.footerLabel.text = [NSString stringWithFormat:@"by %@ on %@", content.creator.userName, dateString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.blurFooterView.dynamic = NO;
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGFloat width=tableView.bounds.size.width;
    CGFloat height=tableView.bounds.size.height;
    JCRBlurView* blurView = [[JCRBlurView alloc] init];
    blurView.frame = CGRectMake(0, 0, width, height);
    
    self.distanceToLootLabel =  [[UILabel alloc] initWithFrame: CGRectMake(10, 8, width, 15)];
    [self setDistanceToLootLabelText];
    [self.distanceToLootLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [blurView addSubview:self.distanceToLootLabel];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, width, 0.5)];
    separator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [blurView addSubview:separator];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    infoButton.center = CGPointMake(width-20, 15);
    [infoButton addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:infoButton];
    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    reportButton.center = CGPointMake(width-50, 15);
    [reportButton addTarget:self action:@selector(reportButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [blurView addSubview:reportButton];
    
    return blurView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 30;
            break;
        default:
            break;
            return 0;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    Content* content = [self.lootContents objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    if([cell isKindOfClass:[ImageViewTableViewCell class]]){
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:content.url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // TODO: progression tracking code
         }
         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 self.lastDownloadedImage.image = image;
                 [self.lastDownloadedImage sizeToFit];
                 TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:image];
                 // Don't forget to set ourselves as the transition delegate
                 viewController.transitioningDelegate = self;
                 [self presentViewController:viewController animated:YES completion:nil];
             }
         }];

    }
    
}

-(void)setDistanceToLootLabelText{
    NSError* error = nil;
    NSInteger distance = [self.locationService getDistanceToLoot:self.loot withError:&error];
    NSString* distanceText = @"Distance to Loot: ";
    NSString* distanceUnknownText = @"undetermined";
    if(distance >= 0){
        self.distanceToLootLabel.text = [NSString stringWithFormat:@"%@%i m",distanceText, distance];
    } else {
        self.distanceToLootLabel.text = [NSString stringWithFormat:@"%@%@",distanceText, distanceUnknownText];
    }
}

#pragma mark - ImagePicker

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    //TODO: work with selected image
    User* u = [User new];
    u.userName = @"Mario";
    Content* c = [Content new];
    c.created = [NSDate date];
    c.creator = u;
    [self postContent:c onLoot:self.loot withImage:image];
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Loading Data from Server

-(void)reloadLootWithContents{
    [self.facade getLoot:self.loot onSuccess:^(Loot *loot) {
        self.loot = loot;
        self.lootContents = [self.loot.contents allObjects];
        [self.tableView reloadData];
    } onFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image{
    [self.facade postContent:content onLoot:self.loot withImage:image onSuccess:^(Content *loot) {
        //TODO
    } onFailure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - Vertigo

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        if([cell isKindOfClass:[ImageViewTableViewCell class]]){
            return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.lastDownloadedImage];
        }
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        if([cell isKindOfClass:[ImageViewTableViewCell class]]){
            return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.lastDownloadedImage];
        }
    }
    return nil;
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
