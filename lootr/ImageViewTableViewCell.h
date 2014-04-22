//
//  ImageViewTableViewCell.h
//  lootr
//
//  Created by Sebastian Bock on 19.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView.h>
#import "Content.h"

@interface ImageViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *footerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;
@property (weak, nonatomic) IBOutlet FXBlurView *blurFooterView;
@end
