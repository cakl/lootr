//
//  LootContentHeader.h
//  lootr
//
//  Created by Sebastian Bock on 19.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "JCRBlurView.h"

@interface LootContentHeader : JCRBlurView
@property (nonatomic, strong) UILabel* distanceToLootLabel;
@property (nonatomic, strong) UIButton* infoButton;
@property (nonatomic, strong) UIButton* reportButton;

@end
