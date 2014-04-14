//
//  LootContentViewController.m
//  lootr
//
//  Created by Sebastian Bock on 09.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootContentViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ServerCaller.h"
#import "ServerCallerFactory.h"
#import "ContentViewController.h"

@interface LootContentViewController ()
@property (nonatomic, strong) id <ServerCaller> serverCaller;
@property (nonatomic, strong) Content* lastSelectedContent;
@property (nonatomic, strong) UIImage* placeholderImage;
@end

@implementation LootContentViewController
static NSString* const dateFormat = @"dd.MMMM yyyy";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self reloadLootWithContents];
    self.placeholderImage = [UIImage imageNamed:@"ExampleImage"];
    
}

-(id <ServerCaller>)serverCaller{
    if (_serverCaller == nil)
    {
        _serverCaller = [ServerCallerFactory createServerCaller];
    }
    return _serverCaller;
}

- (NSInteger)numberOfItemsInSlidingMenu {
    return [self.loot.contents count];
}

- (void)customizeCell:(RPSlidingMenuCell *)slidingMenuCell forRow:(NSInteger)row {
    Content* content = [self.lootsContents objectAtIndex:row];
    slidingMenuCell.textLabel.text = content.creator.userName;
    slidingMenuCell.detailTextLabel.text = [self getFormattedStringFromDate:content.created];
    [slidingMenuCell.backgroundImageView setImageWithURL:content.url placeholderImage:self.placeholderImage];
}

- (void)slidingMenu:(RPSlidingMenuViewController *)slidingMenu didSelectItemAtRow:(NSInteger)row {
    // when a row is tapped do some action like go to another view controller
    self.lastSelectedContent = [self.lootsContents objectAtIndex:row];
    [self performSegueWithIdentifier:@"showContent" sender:self];
}

-(void)reloadLootWithContents{
    [self.serverCaller getLootByIdentifier:[self.loot identifier] onSuccess:^(Loot *loot) {
        self.loot = loot;
        self.lootsContents = [loot.contents allObjects];
        [self.collectionView reloadData];
    } onFailure:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

-(NSString*)getFormattedStringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showContent"]){
        ContentViewController* contentViewController = segue.destinationViewController;
        contentViewController.content = self.lastSelectedContent;
    }
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", @"Write Text", nil];
    [actionSheet showInView:self.view];
}

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
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    //TODO: work with selected image
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    
}

@end
