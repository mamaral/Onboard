//
//  OnboardingViewController.h
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnboardingContentViewController.h"
@import MediaPlayer;

@interface OnboardingViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, OnboardingContentViewControllerDelegate>

// View controllers and background image
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIImage *backgroundImage;

// Masking, blurring, fading, etc.
@property (nonatomic) BOOL shouldMaskBackground;
@property (nonatomic) BOOL shouldBlurBackground;
@property (nonatomic) BOOL shouldFadeTransitions;
@property (nonatomic) BOOL fadePageControlOnLastPage;
@property (nonatomic) BOOL fadeSkipButtonOnLastPage;

// Skipping
@property (nonatomic) BOOL allowSkipping;
@property (nonatomic, strong) dispatch_block_t skipHandler;

// Swiping
@property (nonatomic) BOOL swipingEnabled;

// Page Control
@property (nonatomic) BOOL hidePageControl;
@property (nonatomic, strong) UIPageControl *pageControl;

// Skip Button
@property (nonatomic, strong) UIButton *skipButton;

// Movie player
@property (nonatomic) BOOL stopMoviePlayerWhenDisappear;
@property (nonatomic) MPMoviePlayerController *moviePlayerController;

@property (nonatomic) CGFloat bottomPadding;
@property (nonatomic) CGFloat underPageControlPadding;

// Initializers
+ (instancetype)onboardWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents;
- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents;

+ (instancetype)onboardWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents;
- (instancetype)initWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents;

- (void)moveNextPage;

@property (nonatomic) CGFloat iconSize __attribute__((deprecated("Modify the content view controller's iconSize directly. This property will be removed in the next update.")));
@property (nonatomic) CGFloat iconHeight __attribute__((deprecated("Modify the content view controller's iconHeight directly. This property will be removed in the next update.")));
@property (nonatomic) CGFloat iconWidth __attribute__((deprecated("Modify the content view controller's iconWidth directly. This property will be removed in the next update.")));

@property (nonatomic, strong) UIColor *titleTextColor __attribute__((deprecated("Modify the content view controller's titleLabel directly. This property will be removed in the next update.")));
@property (nonatomic, strong) NSString *titleFontName __attribute__((deprecated("Modify the content view controller's titleLabel directly. This property will be removed in the next update.")));
@property (nonatomic) CGFloat titleFontSize __attribute__((deprecated("Modify the content view controller's titleLabel directly. This property will be removed in the next update.")));

@property (nonatomic, strong) UIColor *bodyTextColor __attribute__((deprecated("Modify the content view controller's bodyLabel directly. This property will be removed in the next update.")));
@property (nonatomic, strong) NSString *bodyFontName __attribute__((deprecated("Modify the content view controller's bodyLabel directly. This property will be removed in the next update.")));
@property (nonatomic) CGFloat bodyFontSize __attribute__((deprecated("Modify the content view controller's bodyLabel directly.")));

@property (nonatomic, strong) UIColor *buttonTextColor __attribute__((deprecated("Modify the content view controller's actionButton directly. This property will be removed in the next update.")));
@property (nonatomic, strong) NSString *buttonFontName __attribute__((deprecated("Modify the content view controller's actionButton directly. This property will be removed in the next update.")));
@property (nonatomic) CGFloat buttonFontSize __attribute__((deprecated("Modify the content view controller's actionButton directly. This property will be removed in the next update.")));

@property (nonatomic, strong) NSString *fontName __attribute__((deprecated("Modify the content view controller's labels directly. This property will be removed in the next update.")));

@property (nonatomic) CGFloat topPadding __attribute__((deprecated("Modify the content view controller's topPadding directly. This property will be removed in the next update.")));
@property (nonatomic) CGFloat underIconPadding __attribute__((deprecated("Modify the content view controller's underIconPadding directly. This property will be removed in the next update.")));
@property (nonatomic) CGFloat underTitlePadding __attribute__((deprecated("Modify the content view controller's underTitlePadding directly. This property will be removed in the next update.")));

@end
