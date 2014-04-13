//
//  ContentViewController.m
//  lootr
//
//  Created by Sebastian Bock on 13.04.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()


@end

@implementation ContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.contentImageView setImageWithURL:self.content.url placeholderImage:[UIImage imageNamed:@"ExampleImage"]];
    [self.scrollView addSubview:self.contentImageView];
    self.contentImageView.center = self.scrollView.center;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.contentImageView.frame.size;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 2.0;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
    return self.contentImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
