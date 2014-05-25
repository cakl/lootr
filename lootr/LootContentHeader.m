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

static NSString *const reportButtonImageName = @"ReportButtonIcon";
static NSString *const lootLabelFont = @"HelveticaNeue-Light";
static CGFloat const lootLabelXPosition = 10;
static CGFloat const lootLabelYPosition = 8;
static CGFloat const lootLabelFontSize = 14;
static CGFloat const separatorThickness = 0.5;
static CGFloat const separatorAlpha = 0.3;
static CGFloat const infoButtonWidth = 40;
static CGFloat const infoButtonRightMargin = 20;
static CGFloat const reportButtonRightMargin = 55;
static CGFloat const reportButtonWidth = 40;
static CGFloat const reportButtonEdgeInset = 8;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        double width = frame.size.width;
        double height = frame.size.height;
        self.distanceToLootLabel =  [[UILabel alloc] initWithFrame: CGRectMake(lootLabelXPosition, lootLabelYPosition, width, (height/2))];
        [self.distanceToLootLabel setFont:[UIFont fontWithName:lootLabelFont size:lootLabelFontSize]];
        [self addSubview:self.distanceToLootLabel];
        
        UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, (height-separatorThickness), width, separatorThickness)];
        separator.backgroundColor = [UIColor colorWithWhite:0 alpha:separatorAlpha];
        [self addSubview:separator];
        
        self.infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.infoButton.frame = CGRectMake(0, 0, infoButtonWidth, height);
        self.infoButton.center = CGPointMake(width-infoButtonRightMargin, height/2);
        [self addSubview:self.infoButton];
        
        self.reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reportButton setImage:[UIImage imageNamed:reportButtonImageName] forState:UIControlStateNormal];
        self.reportButton.frame = CGRectMake(0, 0, reportButtonWidth, height);
        self.reportButton.imageEdgeInsets = UIEdgeInsetsMake(reportButtonEdgeInset, reportButtonEdgeInset, reportButtonEdgeInset, reportButtonEdgeInset);
        self.reportButton.center = CGPointMake(width-reportButtonRightMargin, height/2);
        [self addSubview:self.reportButton];
    }
    return self;
}

@end
