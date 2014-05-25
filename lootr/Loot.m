//
//  Loot.m
//  lootrapp
//
//  Created by Sebastian Bock on 16.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//
// http://stackoverflow.com/questions/254281/best-practices-for-overriding-isequal-and-hash

#import "Loot.h"

@implementation Loot

-(BOOL)isEqual:(id)object {
    if(object == self)
        return YES;
    if(!object || ![object isKindOfClass:[self class]])
        return NO;
    return [self isEqualToLoot:object];
}

-(BOOL)isEqualToLoot:(Loot*)aLoot {
    if(self == aLoot)
        return YES;
    if(![(id)[self identifier] isEqualToNumber:[aLoot identifier]])
        return NO;
    return YES;
}

-(void)setRadiusWithAccuracy:(Accuracy)accuracy {
    self.radius = [NSNumber numberWithInt:accuracy];
}

-(Accuracy)getRadiusAsAccuracy {
    if([self.radius integerValue] == AccuracyNear) return AccuracyNear;
    if([self.radius integerValue] == AccuracyWide) return AccuracyWide;
    return AccuracyDefault;
}

-(NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime*result+[[self identifier] hash];
    result = prime*result+[[self created] hash];
    result = prime*result+[[self title] hash];
    result = prime*result+[[self summary] hash];
    result = prime*result+[[self radius] hash];
    return result;
}

@end