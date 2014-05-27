//
//  TWTViewController.m
//  Translates
//
//  Created by Andrew Hershberger on 5/27/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "TWTViewController.h"

#import "UIView+TWTConstraintsForAutoresizingMask.h"


@interface UIView (TWTTesting)

- (NSArray *)_constraintsEquivalentToAutoresizingMask;

@end


@implementation TWTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(160, 120, 80, 80)];
    [self.view addSubview:testView];

    for (UIViewAutoresizing mask = 0; mask < 8; mask++) {
        testView.autoresizingMask = mask;
        NSLog(@"view: %@", testView);
        NSLog(@"constraints: %@", [testView _constraintsEquivalentToAutoresizingMask]);
        NSLog(@"twt_constraints: %@", [testView twt_constraintsEquivalentToAutoresizingMask]);
    }
}

@end
