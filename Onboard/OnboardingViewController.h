//
//  OnboardingViewController.h
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    UIImage *_backgroundImage;
    UIPageViewController *_pageVC;
    UIPageControl *_pageControl;
    NSArray *_viewControllers;
}

- (id)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents;

@end
