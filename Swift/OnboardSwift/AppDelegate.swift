//
//  AppDelegate.swift
//  OnboardSwift
//
//  Created by Mike on 9/11/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let userHasOnboardedKey = "user_has_onboarded"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        
        application.statusBarStyle = .LightContent
        
        // Determine if the user has completed onboarding yet or not
        var userHasOnboardedAlready = NSUserDefaults.standardUserDefaults().boolForKey(userHasOnboardedKey);
        
        // If the user has already onboarded, setup the normal root view controller for the application
        // without animation like you normally would if you weren't doing any onboarding
        if userHasOnboardedAlready {
            self.setupNormalRootVC(false);
        }
        
        // Otherwise the user hasn't onboarded yet, so set the root view controller for the application to the
        // onboarding view controller generated and returned by this method.
        else {
            self.window!.rootViewController = self.generateOnboardingViewController()
        }
        
        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    func generateOnboardingViewController() -> OnboardingViewController {
        // Generate the first page...
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: "What A Beautiful Photo", body: "This city background image is so beautiful", image: UIImage(named:
            "blue"), buttonText: "Enable Location Services") {
            println("Do something here...");
        }
        
        // Generate the second page...
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: "I'm So Sorry", body: "I can't get over the nice blurry background photo.", image: UIImage(named:
            "red"), buttonText: "Connect With Facebook") {
            println("Do something else here...");
        }
        
        // Generate the third page, and when the user hits the button we want to handle that the onboarding
        // process has been completed.
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: "Seriously Though", body: "Kudos to the photographer.", image: UIImage(named:
            "yellow"), buttonText: "Let's Get Started") {
            self.handleOnboardingCompletion()
        }
        
        // Create the onboarding controller with the pages and return it.
        let onboardingVC: OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "street"), contents: [firstPage, secondPage, thirdPage])
        
        return onboardingVC
    }
    
    func handleOnboardingCompletion() {
        // Now that we are done onboarding, we can set in our NSUserDefaults that we've onboarded now, so in the
        // future when we launch the application we won't see the onboarding again.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: userHasOnboardedKey)
        
        // Setup the normal root view controller of the application, and set that we want to do it animated so that
        // the transition looks nice from onboarding to normal app.
        setupNormalRootVC(true)
    }
    
    func setupNormalRootVC(animated : Bool) {
        // Here I'm just creating a generic view controller to represent the root of my application.
        var mainVC = UIViewController()
        mainVC.title = "Main Application"
        
        // If we want to animate it, animate the transition - in this case we're fading, but you can do it
        // however you want.
        if animated {
           UIView.transitionWithView(self.window!, duration: 0.5, options:.TransitionCrossDissolve, animations: { () -> Void in
                self.window!.rootViewController = mainVC
           }, completion:nil)
        }
        
        // Otherwise we just want to set the root view controller normally.
        else {
            self.window?.rootViewController = mainVC;
        }
    }
}

