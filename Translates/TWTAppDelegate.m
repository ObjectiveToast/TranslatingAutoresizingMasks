//
//  TWTAppDelegate.m
//  Translates
//
//  Created by Andrew Hershberger on 5/27/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "TWTAppDelegate.h"

#import "TWTViewController.h"


@implementation TWTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[TWTViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
