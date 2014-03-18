//
//  RKResponseDescriptorWrapper.h
//  lootrapp
//
//  Created by Sebastian Bock on 17.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKResponseDescriptorWrapper : NSObject
+(RKResponseDescriptor*)getPathPatternCorrectedRKResponseDescriptorWithRKResponseDescriptor:(RKResponseDescriptor*)wrongRKResponseDescriptor;
@end
