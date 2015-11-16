//
//  AppDelegate.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "AppDelegate.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"

static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // determine if the user has onboarded yet or not
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    
    // if the user has already onboarded, just set up the normal root view controller
    // for the application
    if (userHasOnboarded) {
        [self setupNormalRootViewController];
    }
    
    // otherwise set the root view controller to the onboarding view controller
    else {
        self.window.rootViewController = [self generateFirstDemoVC];
//        self.window.rootViewController = [self generateSecondDemoVC];
//        self.window.rootViewController = [self generateThirdDemoVC];
//        self.window.rootViewController = [self generateFourthDemoVC];
//        self.window.rootViewController = [self generateFifthDemoVC];
        
//        __weak typeof(self) weakSelf = self;
//        
//        self.window.rootViewController = [[MyOnboardingViewController alloc] initWithCompletionHandler:^{
//            [weakSelf setupNormalRootViewController];
//        }];
    }
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupNormalRootViewController {
    // create whatever your root view controller is going to be, in this case just a simple view controller
    // wrapped in a navigation controller
    UIViewController *mainVC = [UIViewController new];
    mainVC.title = @"Main Application";

    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
}

- (void)handleOnboardingCompletion {
    // set that we have completed onboarding so we only do it once... for demo
    // purposes we don't want to have to set this every time so I'll just leave
    // this here...
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    
    // transition to the main application
    [self setupNormalRootViewController];
}

- (OnboardingViewController *)generateFirstDemoVC {
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"What A Beautiful Photo" body:@"This city background image is so beautiful." image:[UIImage imageNamed:@"blue"] buttonText:@"Enable Location Services" action:^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Here you can prompt users for various application permissions, providing them useful information about why you'd like those permissions to enhance their experience, increasing your chances they will grant those permissions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"I'm so sorry" body:@"I can't get over the nice blurry background photo." image:[UIImage imageNamed:@"red"] buttonText:@"Connect With Facebook" action:^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Prompt users to do other cool things on startup. As you can see, hitting the action button on the prior page brought you automatically to the next page. Cool, huh?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    secondPage.movesToNextViewController = YES;
    secondPage.viewDidAppearBlock = ^{
        [[[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"You've arrived on the second page, and this alert was displayed from within the page's viewDidAppearBlock." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    };
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Seriously Though" body:@"Kudos to the photographer." image:[UIImage imageNamed:@"yellow"] buttonText:@"Get Started" action:^{
        [self handleOnboardingCompletion];
    }];
    
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;

    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion];
    };
    
    return onboardingVC;
}

- (OnboardingViewController *)generateSecondDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Everything Under The Sun" body:@"The temperature of the photosphere is over 10,000°F." image:nil buttonText:nil action:nil];
    firstPage.topPadding = -15;
    firstPage.underTitlePadding = 160;
    firstPage.titleTextColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.titleFontName = @"SFOuterLimitsUpright";
    firstPage.bodyTextColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.bodyFontName = @"NasalizationRg-Regular";
    firstPage.bodyFontSize = 18;
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Every Second" body:@"600 million tons of protons are converted into helium atoms." image:nil buttonText:nil action:nil];
    secondPage.titleFontName = @"SFOuterLimitsUpright";
    secondPage.underTitlePadding = 170;
    secondPage.topPadding = 0;
    secondPage.titleTextColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyTextColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyFontName = @"NasalizationRg-Regular";
    secondPage.bodyFontSize = 18;
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"We're All Star Stuff" body:@"Our very bodies consist of the same chemical elements found in the most distant nebulae, and our activities are guided by the same universal rules." image:nil buttonText:@"Explore the universe" action:^{
        [self handleOnboardingCompletion];
    }];
    thirdPage.topPadding = 10;
    thirdPage.underTitlePadding = 160;
    thirdPage.bottomPadding = -10;
    thirdPage.titleFontName = @"SFOuterLimitsUpright";
    thirdPage.titleTextColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.bodyTextColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.buttonTextColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    thirdPage.bodyFontName = @"NasalizationRg-Regular";
    thirdPage.bodyFontSize = 15;
    thirdPage.buttonFontName = @"SpaceAge";
    thirdPage.buttonFontSize = 17;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"sun" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundVideoURL:movieURL contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    onboardingVC.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    return onboardingVC;
}

- (OnboardingViewController *)generateThirdDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"It's one small step for a man..." body:@"The first man on the moon, Buzz Aldrin, only had one photo taken of him while on the lunar surface due to an unexpected call from Dick Nixon." image:[UIImage imageNamed:@"space1"] buttonText:nil action:nil];
    firstPage.bodyFontSize = 25;
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"The Drake Equation" body:@"In 1961, Frank Drake proposed a probabilistic formula to help estimate the number of potential active and radio-capable extraterrestrial civilizations in the Milky Way Galaxy." image:[UIImage imageNamed:@"space2"] buttonText:nil action:nil];
    secondPage.bodyFontSize = 24;
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Cold Welding" body:@"Two pieces of metal without any coating on them will form into one piece in the vacuum of space." image:[UIImage imageNamed:@"space3"] buttonText:nil action:nil];
    
    OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc] initWithTitle:@"Goodnight Moon" body:@"Every year the moon moves about 3.8cm further away from the Earth." image:[UIImage imageNamed:@"space4"] buttonText:@"See Ya Later!" action:nil];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"milky_way.jpg"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldBlurBackground = YES;
    return onboardingVC;
}

- (OnboardingViewController *)generateFourthDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"If you can't explain it simply, you don't know it well enough.\"" body:@"                 - Einsten" image:[UIImage imageNamed:@""] buttonText:nil action:nil];
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"If you wish to make an apple pie from scratch, you must first invent the universe.\"" body:@"                 - Sagan" image:nil buttonText:nil action:nil];
    secondPage.topPadding = 0;
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"That which can be asserted without evidence, can be dismissed without evidence.\"" body:@"                 - Hitchens" image:nil buttonText:nil action:nil];
    thirdPage.titleFontSize = 33;
    thirdPage.bodyFontSize = 25;
    
    OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"Scientists have become the bearers of the torch of discovery in our quest for knowledge.\"" body:@"                 - Hawking" image:nil buttonText:nil action:nil];
    fourthPage.titleFontSize = 28;
    fourthPage.bodyFontSize = 24;
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"yellowbg"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.titleTextColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1.0];;
    onboardingVC.bodyTextColor = [UIColor colorWithRed:244/255.0 green:64/255.0 blue:40/255.0 alpha:1.0];
    onboardingVC.fontName = @"HelveticaNeue-Italic";
    return onboardingVC;
}

- (OnboardingViewController *)generateFifthDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Tri-tip bacon shankle" body:@"Bacon ipsum dolor amet cow filet mignon porchetta ham hamburger pork chop venison landjaeger ribeye drumstick beef ribs tongue." videoURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video1" ofType:@"mp4"]] buttonText:nil action:nil];
    firstPage.topPadding = -15;
    firstPage.underTitlePadding = 160;
    firstPage.titleTextColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.titleFontName = @"SFOuterLimitsUpright";
    firstPage.bodyTextColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    firstPage.bodyFontName = @"NasalizationRg-Regular";
    firstPage.bodyFontSize = 18;
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Ball tip hamburger" body:@"Bacon ipsum dolor amet kielbasa landjaeger ham fatback frankfurter pork beef pig strip steak pancetta tenderloin pork chop." videoURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video2" ofType:@"mp4"]] buttonText:nil action:nil];
    secondPage.titleFontName = @"SFOuterLimitsUpright";
    secondPage.underTitlePadding = 170;
    secondPage.topPadding = 0;
    secondPage.titleTextColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyTextColor = [UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    secondPage.bodyFontName = @"NasalizationRg-Regular";
    secondPage.bodyFontSize = 18;
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Sausage prosciutto flank capicola" body:@"Bacon ipsum dolor amet tail sausage salami filet mignon spare ribs hamburger." videoURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video3" ofType:@"mp4"]] buttonText:@"Tap me" action:^{
        [self handleOnboardingCompletion];
    }];
    thirdPage.topPadding = 10;
    thirdPage.underTitlePadding = 160;
    thirdPage.bottomPadding = -10;
    thirdPage.titleFontName = @"SFOuterLimitsUpright";
    thirdPage.titleTextColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.bodyTextColor = [UIColor colorWithRed:58/255.0 green:105/255.0 blue:136/255.0 alpha:1.0];
    thirdPage.buttonTextColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    thirdPage.bodyFontName = @"NasalizationRg-Regular";
    thirdPage.bodyFontSize = 15;
    thirdPage.buttonFontName = @"SpaceAge";
    thirdPage.buttonFontSize = 17;
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"milky_way.jpg"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:239/255.0 green:88/255.0 blue:35/255.0 alpha:1.0];
    onboardingVC.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    return onboardingVC;
}

@end