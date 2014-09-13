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

@property (nonatomic) BOOL shouldMaskBackground;
@property (nonatomic) BOOL shouldBlurBackground;

////////////////////////////////////////////////////////////////////
// These are convenience properties for content view customization, so you
// can set these properties on the master onboarding view controller and
// it will make sure they trickle down to each content view controller,
// rather than having to individually set the same values on each
@property (nonatomic) CGFloat iconSize;

@property (nonatomic, retain) UIColor *titleTextColor;
@property (nonatomic, retain) UIColor *bodyTextColor;
@property (nonatomic, retain) UIColor *buttonTextColor;

@property (nonatomic, retain) NSString *fontName;
@property (nonatomic) CGFloat titleFontSize;
@property (nonatomic) CGFloat bodyFontSize;

@property (nonatomic) CGFloat topPadding;
@property (nonatomic) CGFloat underIconPadding;
@property (nonatomic) CGFloat underTitlePadding;
@property (nonatomic) CGFloat bottomPadding;
////////////////////////////////////////////////////////////////////

- (id)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents;


// Getters for tests only
- (NSArray *)contentViewControllers;

@end
