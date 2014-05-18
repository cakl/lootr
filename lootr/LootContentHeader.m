//
//  LootContentHeader.m
//  lootr
//
//  Created by Sebastian Bock on 19.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "LootContentHeader.h"

@interface LootContentHeader ()

@end

@implementation LootContentHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        double width = frame.size.width;
        double height = frame.size.height;
        self.distanceToLootLabel =  [[UILabel alloc] initWithFrame: CGRectMake(10, 8, width, (height/2))];
        [self.distanceToLootLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        [self addSubview:self.distanceToLootLabel];
        
        double separatorThickness = 0.5;
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, (height-separatorThickness), width, separatorThickness)];
        separator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:separator];
        
        self.infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.infoButton.frame = CGRectMake(0, 0, 40, height);
        self.infoButton.center = CGPointMake(width-20, 20);
        //[self.infoButton addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.infoButton];
        
        self.reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reportButton setImage:[UIImage imageNamed:@"ReportButtonIcon"] forState:UIControlStateNormal];
        self.reportButton.frame = CGRectMake(0, 0, 40, height);
        self.reportButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        self.reportButton.center = CGPointMake(width-55, 20);
        //[self.reportButton addTarget:self action:@selector(reportButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.reportButton];
    }
    return self;
}

@end
