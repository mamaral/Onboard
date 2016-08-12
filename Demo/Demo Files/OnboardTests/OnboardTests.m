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
#import "OnboardingContentViewController_Private.h"

@interface OnboardTests : XCTestCase

@end

@interface OnboardingContentViewController (Testing)

@end

@implementation OnboardTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testContentViewControllers {
    // This tests that when we create an onboarding view controller with an array of content
    // view controllers at init-time, the view controllers are correctly set.
    NSArray *contents = [self generateStockContentVCS];
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:nil contents:contents];
    NSArray *contentsFromController = onboardingVC.viewControllers;
    
    for (NSInteger index = 0; index < contents.count; index++) {
        OnboardingContentViewController *originalContentVC = contents[index];
        OnboardingContentViewController *passedContentVC = contentsFromController[index];
        XCTAssertEqualObjects(originalContentVC, passedContentVC, @"The content view controllers from the controller don't match.");
    }
}

- (void)testDefaultValues {
    // This tests that the default values on the onboarding view controller are set properly.
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:nil contents:nil];
    XCTAssertTrue(onboardingVC.shouldMaskBackground, @"The background should be masked by default.");
    XCTAssertFalse(onboardingVC.shouldBlurBackground, @"The background should not be blurred by default.");
}

- (void)testActionHandler {
    XCTestExpectation *expectation = [self expectationWithDescription:@"callback"];
    OnboardingContentViewController *contentVC = [[OnboardingContentViewController alloc] initWithTitle:@"T1" body:@"B1" image:nil buttonText:nil action:^{
        [expectation fulfill];
    }];
    [contentVC handleButtonPressed];
    [self waitForExpectationsWithTimeout:1. handler:nil];
}

- (void)testActionHandlerWithOnboardController {
    XCTestExpectation *expectation = [self expectationWithDescription:@"callback"];
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:nil contents:nil];
    OnboardingContentViewController *contentVC = [[OnboardingContentViewController alloc] initWithTitle:@"T1" body:@"B1" image:nil buttonText:nil actionBlock:^(OnboardingViewController *onboardController) {
        if([onboardingVC isEqual:onboardController]) {
            [expectation fulfill];
        }
    }];
    onboardingVC.viewControllers = @[contentVC];
    [onboardingVC viewDidLoad];
    [contentVC handleButtonPressed];
    [self waitForExpectationsWithTimeout:1. handler:nil];
}

- (void)testConvenientInitializer {
    OnboardingContentViewController *contentVC = [OnboardingContentViewController contentWithTitle:@"T1" body:@"B1" image:nil buttonText:nil actionBlock:nil];
    XCTAssertTrue([contentVC isKindOfClass:[OnboardingContentViewController class]], @"should get content controller");
}


#pragma mark - Test utilities

- (NSArray *)generateStockContentVCS {
    // Create and return an array of content view controllers.
    OnboardingContentViewController *contentVC1 = [[OnboardingContentViewController alloc] initWithTitle:@"T1" body:@"B1" image:nil buttonText:nil action:nil];
    OnboardingContentViewController *contentVC2 = [[OnboardingContentViewController alloc] initWithTitle:@"T2" body:@"B2" image:nil buttonText:nil action:nil];
    OnboardingContentViewController *contentVC3 = [[OnboardingContentViewController alloc] initWithTitle:@"T3" body:@"B3" image:nil buttonText:nil action:nil];
    OnboardingContentViewController *contentVC4 = [[OnboardingContentViewController alloc] initWithTitle:@"T4" body:@"B4" image:nil buttonText:nil action:nil];
    return @[contentVC1, contentVC2, contentVC3, contentVC4];
}

@end
