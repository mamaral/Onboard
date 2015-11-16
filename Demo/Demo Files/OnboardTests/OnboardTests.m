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

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) NSURL *videoURL;
- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL;

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

- (void)testContentViewControllerWithVideo {
    // This tests that when we create an onboarding content view controller with a video url

    OnboardingContentViewController *contentVC = [[OnboardingContentViewController alloc] initWithTitle:@"T1" body:@"B1" videoURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sun" ofType:@"mp4"]] buttonText:nil action:nil];
    [contentVC view];//trick to call viewDidLoad
    
    XCTAssertNotNil(contentVC.moviePlayerController, @"The moviePlayerController should exist.");
    XCTAssertNotNil(contentVC.videoURL, @"The videoURL should exist.");
}

- (void)testGetThumbnailImageForVideo {
    // This tests that when we try to get the video thumbnail on an onboarding content view controller with a video url
    
    OnboardingContentViewController *contentVC = [[OnboardingContentViewController alloc] initWithTitle:@"T1" body:@"B1" videoURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sun" ofType:@"mp4"]] buttonText:nil action:nil];
    
    UIImage *thumbnail = [contentVC thumbnailImageForVideo:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sun" ofType:@"mp4"]]];
    UIImage *nilThumbnail = [contentVC thumbnailImageForVideo:nil];
    
    XCTAssertNotNil(thumbnail, @"The video thumbnail should exist.");
    XCTAssertNil(nilThumbnail, @"The video thumbnail should not exist for a nil URL.");
}

- (void)testDefaultValues {
    // This tests that the default values on the onboarding view controller are set properly.
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:nil contents:nil];
    XCTAssertTrue(onboardingVC.shouldMaskBackground, @"The background should be masked by default.");
    XCTAssertFalse(onboardingVC.shouldBlurBackground, @"The background should not be blurred by default.");
}

- (void)testConvenienceSetters {
    // This tests that when we use the convenience setter methods on the master onboaring view controller,
    // the properties correctly trickle down to each of the child content view controllers.
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:nil contents:[self generateStockContentVCS]];
    
    CGFloat testIconSize = 80;
    onboardingVC.iconSize = testIconSize;
    
    UIColor *testColor = [UIColor purpleColor];
    onboardingVC.titleTextColor = testColor;
    onboardingVC.bodyTextColor = testColor;
    onboardingVC.buttonTextColor = testColor;
    
    NSString *testFontName = @"Helvetica-LightOblique";
    onboardingVC.fontName = testFontName;
    
    CGFloat testFontSize = 12;
    onboardingVC.titleFontSize = testFontSize;
    onboardingVC.bodyFontSize = testFontSize;
    
    CGFloat testPadding = 22;
    onboardingVC.topPadding = testPadding;
    onboardingVC.underIconPadding = testPadding;
    onboardingVC.underTitlePadding = testPadding;
    onboardingVC.bottomPadding = testPadding;
    
    NSArray *contentsFromController = onboardingVC.viewControllers;
    
    for (OnboardingContentViewController *contentVC in contentsFromController) {
        XCTAssert(contentVC.titleTextColor == testColor, @"The content view controller's title text color is invalid.");
        XCTAssert(contentVC.bodyTextColor == testColor, @"The content view controller's body text color is invalid.");
        XCTAssert(contentVC.buttonTextColor == testColor, @"The content view controller's button test color is invalid.");
        XCTAssert(contentVC.titleFontSize == testFontSize, @"The content view controller's title fotn size is invalid.");
        XCTAssert(contentVC.bodyFontSize == testFontSize, @"The content view controller's body font size is invalid.");
        XCTAssert(contentVC.topPadding == testPadding, @"The content view controller's top padding is invalid.");
        XCTAssert(contentVC.underIconPadding == testPadding, @"The content view controller's under icon padding is invalid.");
        XCTAssert(contentVC.underTitlePadding == testPadding, @"The content view controller's under title padding is invalid.");
        XCTAssert(contentVC.bottomPadding == testPadding, @"The content view controller's bottom padding is invalid.");
    }
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
