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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIViewController *mainVC = [UIViewController new];
    mainVC.title = @"Main Application";
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = nc;
    
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"What A Beautiful Photo" body:@"This city background image is so beautiful." image:[UIImage imageNamed:@"blue"] buttonText:@"Enable Location Services" action:^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Here you can prompt users for various application permissions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"I'm so sorry" body:@"I can't get over the nice blurry background photo." image:[UIImage imageNamed:@"red"] buttonText:@"Connect With Facebook" action:^{
                [[[UIAlertView alloc] initWithTitle:nil message:@"Prompt users to do other cool things on startup." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Seriously Though" body:@"Kudos to the photographer." image:[UIImage imageNamed:@"yellow"] buttonText:@"Get Started" action:^{
        [nc dismissViewControllerAnimated:YES completion:nil];
    }];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];
    
    [nc presentViewController:onboardingVC animated:YES completion:nil];
    
    return YES;
}

@end