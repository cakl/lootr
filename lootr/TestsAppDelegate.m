//
//  TestsAppDelegate.m
//  lootr
//
//  Created by Sebastian Bock on 22.05.14.
//  Copyright (c) 2014 Hochschule Rapperswil. All rights reserved.
//

#import "TestsAppDelegate.h"

@implementation TestsAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end