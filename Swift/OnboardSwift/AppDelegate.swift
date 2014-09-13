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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: "What A Beautiful Photo", body: "This city background image is so beautiful", image: UIImage(named:
            "blue"), buttonText: "Enable Location Services") {
        }
        
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: "I'm So Sorry", body: "I can't get over the nice blurry background photo.", image: UIImage(named:
            "red"), buttonText: "Connect With Facebook") {
        }
        
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: "Seriously Though", body: "Kudos to the photographer.", image: UIImage(named:
            "yellow"), buttonText: "Let's Get Started") {
        }
        
        let onboardingVC: OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "street"), contents: [firstPage, secondPage, thirdPage])
        
        application.statusBarStyle = .LightContent
        self.window?.rootViewController = onboardingVC
        self.window!.makeKeyAndVisible()
        
        return true
    }
}

