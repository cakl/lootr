//
//  main.m
//  lootr
//
//  Created by Sebastian Bock on 17.03.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "AppDelegate.h"

//http://stackoverflow.com/questions/15714697/unit-testing-in-xcode-does-it-run-the-app/20588035#20588035
int main(int argc, char* argv[]) {
    int returnValue;
    @autoreleasepool {
        BOOL inTests = (NSClassFromString(@"SenTestCase") != nil || NSClassFromString(@"XCTest") != nil);
        if(inTests) {
            returnValue = UIApplicationMain(argc, argv, nil, @"TestsAppDelegate");
        } else {
            returnValue = UIApplicationMain(argc, argv, nil, @"AppDelegate");
        }
    }
    return returnValue;
}