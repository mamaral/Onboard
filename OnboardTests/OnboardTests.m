//
//  OnboardTests.m
//  OnboardTests
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"

@interface OnboardTests : XCTestCase

@end

@implementation OnboardTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testContentViewControllers {
    // create some content view controllers, create an onboaring view controller with an array of these
    // view controllers, get the view controllers after the controller was initialized, and make sure their
    // contents are correct
    OnboardingContentViewController *contentVC1 = [[OnboardingContentViewController alloc] initWithTitle:@"Title 1" body:@"Body 1" image:nil buttonText:nil action:nil];
    OnboardingContentViewController *contentVC2 = [[OnboardingContentViewController alloc] initWithTitle:@"Title 2" body:@"Body 2" image:nil buttonText:nil action:nil];
    OnboardingContentViewController *contentVC3 = [[OnboardingContentViewController alloc] initWithTitle:@"Title 3" body:@"Body 3" image:nil buttonText:nil action:nil];
    OnboardingContentViewController *contentVC4 = [[OnboardingContentViewController alloc] initWithTitle:@"Title 4" body:@"Body 4" image:nil buttonText:nil action:nil];
    
    NSArray *contents = @[contentVC1, contentVC2, contentVC3, contentVC4];
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:nil contents:contents];
    
    NSArray *contentsFromController = [onboardingVC contentViewControllers];
    
    for (NSInteger index = 0; index < contents.count; index++) {
        OnboardingContentViewController *originalContentVC = contents[index];
        OnboardingContentViewController *passedContentVC = contentsFromController[index];
        XCTAssertEqualObjects(originalContentVC, passedContentVC, @"The content view controllers from the controller don't match.");
    }
}

@end
