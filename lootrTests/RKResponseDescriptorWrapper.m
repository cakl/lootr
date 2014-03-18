//
//  RKResponseDescriptorWrapper.m
//  lootrapp
//
//  Created by Sebastian Bock on 17.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "RKResponseDescriptorWrapper.h"

@implementation RKResponseDescriptorWrapper

+(RKResponseDescriptor*)getPathPatternCorrectedRKResponseDescriptorWithRKResponseDescriptor:(RKResponseDescriptor*)wrongRKResponseDescriptor{
    
    return [RKResponseDescriptor responseDescriptorWithMapping:wrongRKResponseDescriptor.mapping method:wrongRKResponseDescriptor.method pathPattern:[NSString stringWithFormat:@"/lootrserver/%@",wrongRKResponseDescriptor.pathPattern] keyPath:wrongRKResponseDescriptor.keyPath statusCodes:wrongRKResponseDescriptor.statusCodes];
}


@end