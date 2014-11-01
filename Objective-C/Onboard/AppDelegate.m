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
    // for the application, but don't animate it because there's no transition in this case
    if (userHasOnboarded) {
        [self setupNormalRootViewControllerAnimated:NO];
    }
    
    // otherwise set the root view controller to the onboarding view controller
    else {
        self.window.rootViewController = [self generateFirstDemoVC];
//        self.window.rootViewController = [self generateSecondDemoVC];
//        self.window.rootViewController = [self generateThirdDemoVC];
//        self.window.rootViewController = [self generateFourthDemoVC];
//        self.window.rootViewController = [self generateFifthDemoVC];
    }
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupNormalRootViewControllerAnimated:(BOOL)animated {
    // create whatever your root view controller is going to be, in this case just a simple view controller
    // wrapped in a navigation controller
    UIViewController *mainVC = [UIViewController new];
    mainVC.title = @"Main Application";
    
    // if we want to animate the transition, do it
    if (animated) {
        [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        } completion:nil];
    }
    
    // otherwise just set the root view controller normally without animation
    else {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    }
}

- (void)handleOnboardingCompletion {
    // set that we have completed onboarding so we only do it once
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    
    // animate the transition to the main application
    [self setupNormalRootViewControllerAnimated:YES];
}

- (OnboardingViewController *)generateFirstDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"What A Beautiful Photo" body:@"This city background image is so beautiful." image:[UIImage imageNamed:@"blue"] buttonText:@"Enable Location Services" action:^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Here you can prompt users for various application permissions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    firstPage.movesToNextViewController = YES;
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"I'm so sorry" body:@"I can't get over the nice blurry background photo." image:[UIImage imageNamed:@"red"] buttonText:@"Connect With Facebook" action:^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Prompt users to do other cool things on startup." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    secondPage.movesToNextViewController = YES;
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Seriously Though" body:@"Kudos to the photographer." image:[UIImage imageNamed:@"yellow"] buttonText:@"Get Started" action:^{
        [self handleOnboardingCompletion];
    }];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];

    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion];
    };
    
    return onboardingVC;
}

- (OnboardingViewController *)generateSecondDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"This is fucking awesome" body:@"For realsies." image:nil buttonText:nil action:nil];
    firstPage.topPadding = 150;
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"I'm so sorry" body:@"I can't get over the nice blurry background photo." image:nil buttonText:nil action:nil];
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Seriously Though" body:@"Kudos to the photographer." image:nil buttonText:@"Get Started" action:^{
        [self handleOnboardingCompletion];
    }];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"crack" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundVideoURL:movieURL contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
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
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Organize" body:@"Everything has its place. We take care of the housekeeping for you. " image:[UIImage imageNamed:@"layers"] buttonText:nil action:nil];
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Relax" body:@"Grab a nice beverage, sit back, and enjoy the experience." image:[UIImage imageNamed:@"coffee"] buttonText:nil action:nil];
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Rock Out" body:@"Import your favorite tunes and jam out while you browse." image:[UIImage imageNamed:@"headphones"] buttonText:nil action:nil];
    
    OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc] initWithTitle:@"Experiment" body:@"Try new things, explore different combinations, and see what you come up with!" image:[UIImage imageNamed:@"testtube"] buttonText:@"Let's Get Started" action:nil];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"purple"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.iconSize = 160;
    onboardingVC.fontName = @"HelveticaNeue-Thin";
    return onboardingVC;
}

- (OnboardingViewController *)generateFifthDemoVC {
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

@end