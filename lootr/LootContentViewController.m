//
//  TestTableViewController.m
//  lootr
//
//  Created by Sebastian Bock on 17.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootContentViewController.h"
#import "ImageViewTableViewCell.h"
#import "Facade.h"
#import "LocationService.h"
#import "ServerCallerFacadeFactory.h"
#import <JCRBlurView.h>
#import <UIImageView+WebCache.h>
#import "SVProgressHUD+Lootr.h"
#import <URBMediaFocusViewController.h>
#import "LootContentHeader.h"

@interface LootContentViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSArray* lootContents;
@property (nonatomic, strong) id<Facade> facade;
@property (nonatomic, strong) LocationService* locationService;
@property (nonatomic, strong) LootContentHeader* contentHeader;
@property (nonatomic, strong) UITextField* reportTextField;
@property (nonatomic, strong) URBMediaFocusViewController* mediaFocusController;

@end

@implementation LootContentViewController

static NSString *const CellIdentifierDetailed = @"ImageCell";
static int const sectionHeaderHeight = 40;

#pragma mark - Initialization

-(id <Facade>)facade {
    if(_facade == nil) {
        _facade = [ServerCallerFacadeFactory createFacade];
    }
    return _facade;
}

-(LocationService*)locationService {
    if(_locationService == nil) {
        _locationService = [[LocationService alloc] init];
    }
    return _locationService;
}

-(instancetype)initWithFacade:(id <Facade>)facade {
    self = [super init];
    if(self) {
        self.facade = facade;
    }
    return self;
}

#pragma mark - UIViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = self.loot.title;
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    UIBarButtonItem* addBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"lootcontentviewcontroller.addbutton.title", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonPressed)];
    self.navigationItem.rightBarButtonItem = addBarButton;
    
    self.mediaFocusController = [[URBMediaFocusViewController alloc] init];
    self.mediaFocusController.parallaxEnabled = NO;
    self.mediaFocusController.shouldRotateToDeviceOrientation = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [self reloadLootWithContents];
}

#pragma mark - GUI io messages

-(void)refresh:(UIRefreshControl*)refreshControl {
    [self reloadLootWithContents];
    [self setDistanceToLootLabelText];
    [refreshControl endRefreshing];
}

-(void)infoButtonPressed {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:self.loot.title
                                                    message:self.loot.summary
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)reportButtonPressed {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"lootcontentviewcontroller.report.alert.title", nil)
                                                    message:NSLocalizedString(@"lootcontentviewcontroller.report.alert.message", nil)
                                                   delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"lootcontentviewcontroller.report.alert.reportbutton", nil),nil];
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog show];
    self.reportTextField = [dialog textFieldAtIndex:0];
}

-(void)addBarButtonPressed {
    if([self.locationService isCurrentLocationInRadiusOfLoot:self.loot]) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"lootcontentviewcontroller.actionsheet.takephoto", nil), NSLocalizedString(@"lootcontentviewcontroller.actionsheet.choosephoto", nil), nil];
        [actionSheet showInView:self.view];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"lootcontentviewcontroller.add.alert.title", nil)
                                                        message:NSLocalizedString(@"lootcontentviewcontroller.add.alert.message", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        Report* report = [Report new];
        report.purpose = self.reportTextField.text;
        report.loot = self.loot;
        [self postReport:report];
    }
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.loot.contents count];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    Content* content = [self.lootContents objectAtIndex:indexPath.row];
    
    ImageViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierDetailed];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [self blurContentOverlay:cell.blurOverlayView];
    [cell.fullImageView setImageWithURL:content.thumb completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType) {
        [cell.blurFooterView setNeedsDisplay];
        [cell.blurOverlayView setNeedsDisplay];
    }];
    
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString* dateString = [dateFormatter stringFromDate:content.created];
    
    cell.footerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"lootcontentviewcontroller.content.postedby%@on%@", nil), content.creator.userName, dateString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.blurFooterView.dynamic = NO;
    cell.blurOverlayView.dynamic = NO;
    return cell;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    if(section==0) {
        CGFloat width = tableView.bounds.size.width;
        self.contentHeader = [[LootContentHeader alloc] initWithFrame:CGRectMake(0, 0, width, sectionHeaderHeight)];
        [self setDistanceToLootLabelText];
        [self.contentHeader.infoButton addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentHeader.reportButton addTarget:self action:@selector(reportButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        return self.contentHeader;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return (section)?0:sectionHeaderHeight;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if([self.locationService isCurrentLocationInRadiusOfLoot:self.loot]) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        Content* content = [self.lootContents objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        if([cell isKindOfClass:[ImageViewTableViewCell class]]) {
            [SVProgressHUD showApropriateHUD];
            SDWebImageManager* manager = [SDWebImageManager sharedManager];
            [manager downloadWithURL:content.url options:SDWebImageProgressiveDownload progress:nil
             completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, BOOL finished)
             {
                 if(image && finished) {
                     ImageViewTableViewCell* imageCell = (ImageViewTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                     [SVProgressHUD dismiss];
                     [self.mediaFocusController showImage:image fromView:imageCell.fullImageView];
                 } else {
                     [SVProgressHUD dismiss];
                 }
             }];
        }
    }
}

#pragma mark - GUI Helper LocationService based

-(void)setDistanceToLootLabelText {
    NSString* distanceText = NSLocalizedString(@"lootcontentviewcontroller.content.distancelabel", nil);
    NSString* distanceUnknownText = NSLocalizedString(@"lootcontentviewcontroller.content.distanceundeterminedlabel", nil);
    DistanceTreshold distanceThreshold = [self.locationService getDistanceThresholdfromCurrentLocationToLoot:self.loot];
    switch(distanceThreshold) {
        case DistanceTresholdUndetermined:
        {
            self.contentHeader.distanceToLootLabel.text = [NSString stringWithFormat:@"%@ %@", distanceText, distanceUnknownText];
        }
            break;
        case DistanceTresholdMoreThanFiveHundredMeters:
        {
            self.contentHeader.distanceToLootLabel.text = [NSString stringWithFormat:@">%im %@", DistanceTresholdFiveHundredMeters, distanceText];
        }
            break;
        default:
        {
            self.contentHeader.distanceToLootLabel.text = [NSString stringWithFormat:@"<%im %@", distanceThreshold, distanceText];
        }
            break;
    }
}

-(void)blurContentOverlay:(FXBlurView*)blurOverlay {
    DistanceTreshold distanceThreshold = [self.locationService getDistanceThresholdfromCurrentLocationToLoot:self.loot];
    if([self.locationService isCurrentLocationInRadiusOfLoot:self.loot]) {
        blurOverlay.blurEnabled = NO;
    } else {
        blurOverlay.blurRadius = [self blurRadiusOfDistanceThreshold:distanceThreshold accuracy:[self.loot getRadiusAsAccuracy]];
    }
}

-(float)blurRadiusOfDistanceThreshold:(DistanceTreshold)threshold accuracy:(Accuracy)accuracy {
    int x = threshold;
    if(x <= accuracy) return 0;
    if(accuracy < x < 500+accuracy) return sqrt(16/5*(x-accuracy));
    if(500+accuracy < x) return 40;
    return 40;
}

#pragma mark - ImagePicker

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

-(void)takeNewPhotoFromCamera {
    [self presentImagePickerControllerBySourceType:UIImagePickerControllerSourceTypeCamera];
}

-(void)choosePhotoFromExistingImages {
    [self presentImagePickerControllerBySourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)presentImagePickerControllerBySourceType:(UIImagePickerControllerSourceType)sourceType {
    if([UIImagePickerController isSourceTypeAvailable: sourceType]) {
        UIImagePickerController* controller = [[UIImagePickerController alloc] init];
        controller.sourceType = sourceType;
        controller.allowsEditing = YES;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        controller.delegate = self;
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage* image = [info valueForKey:UIImagePickerControllerEditedImage];
    Content* c = [Content new];
    c.created = [NSDate date];
    [self postContent:c onLoot:self.loot withImage:image];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Loading Data from Server

-(void)reloadLootWithContents {
    [self.facade getLoot:self.loot onSuccess:^(Loot* loot) {
        self.loot = loot;
        self.lootContents = [self.loot.contents allObjects];
        [self.tableView reloadData];
    } onFailure:^(NSError* error) {
        NSLog(@"%@", error);
    }];
}

-(void)postContent:(Content*)content onLoot:(Loot*)loot withImage:(UIImage*)image {
    [SVProgressHUD showApropriateHUD];
    [self.facade postContent:content onLoot:self.loot withImage:image onSuccess:^(Content* loot) {
        [SVProgressHUD dismiss];
        [self reloadLootWithContents];
    } onFailure:^(NSError* error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
    }];
}

-(void)postReport:(Report*)report {
    [SVProgressHUD showApropriateHUD];
    [self.facade postReport:report onSuccess:^(Report* loot) {
        [SVProgressHUD dismiss];
        NSLog(@"success");
    } onFailure:^(NSError* error) {
        [SVProgressHUD dismiss];
        NSLog(@"failure");
    }];
}

@end
