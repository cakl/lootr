//
//  ContentViewController.h
//  lootr
//
//  Created by Sebastian Bock on 13.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"

@interface ContentViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) Content* content;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;
@end
