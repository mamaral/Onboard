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

/**
 * @brief The onboarding content view controllers.
 */
@property (nonatomic, strong) NSArray *viewControllers;


/**
 * @brief The background image that will be visible through the content view controllers.
 */
@property (nonatomic, strong) UIImage *backgroundImage;


/**
 * @brief Determines whether or not the background will be masked. The default value of this property is YES.
 */
@property (nonatomic) BOOL shouldMaskBackground;


/**
 * @brief Determines whether or not the background will be blurred. The default value of this property is NO;
 */
@property (nonatomic) BOOL shouldBlurBackground;


/**
 * @brief Determines whether or not the contents on screen will fade as the user swipes between pages. The default value of this property is NO.
 */
@property (nonatomic) BOOL shouldFadeTransitions;


/**
 * @brief Determines whether or not the background will be masked. The default value of this property is NO.
 */
@property (nonatomic) BOOL fadePageControlOnLastPage;


/**
 * @brief Determines whether or not the skip button will fade away on the last page. The default value of this property is NO.
 */
@property (nonatomic) BOOL fadeSkipButtonOnLastPage;


/**
 * @brief Determines whether or not the ship button will be shown. The default value of this property is NO.
 */
@property (nonatomic) BOOL allowSkipping;


/**
 * @brief A block that will be executed when the skip button is pressed.
 */
@property (nonatomic, strong) dispatch_block_t skipHandler;


/**
 * @brief Determines whether or not swiping is enabled between pages. The default value of this property is YES.
 */
@property (nonatomic) BOOL swipingEnabled;


/**
 * @brief Determines whether or not the page cotrol will be visible.
 */
@property (nonatomic, strong) UIPageControl *pageControl;


/**
 * @brief The skip button that allows users to skip onboarding anytime.
 */
@property (nonatomic, strong) UIButton *skipButton;


/**
 * @brief Determines whether or not the movie player stops playing when the view disappears.
 */
@property (nonatomic) BOOL stopMoviePlayerWhenDisappear;


/**
 * @brief The movie player controller used to play background movies.
 */
@property (nonatomic) MPMoviePlayerController *moviePlayerController;


/**
 * @brief The padding between the bottom of the screen and the bottom of the page control.
 */
@property (nonatomic) CGFloat underPageControlPadding;


/**
 * @brief Convenience class initializer for onboarding with a backround image.
 * @return An instance of OnboardingViewController with the provided background image and content view controllers.
 */
+ (instancetype)onboardWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents;


/**
 * @brief Initializer for onboarding with a backround video.
 * @return An instance of OnboardingViewController with the provided background video and content view controllers.
 */
- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents;


/**
 * @brief Convenience class initializer for onboarding with a backround video.
 * @return An instance of OnboardingViewController with the provided background video and content view controllers.
 */
+ (instancetype)onboardWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents;


/**
 * @brief Initializer for onboarding with a backround video.
 * @return An instance of OnboardingViewController with the provided background video and content view controllers.
 */
- (instancetype)initWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents;


/**
 * @brief Method to tell the onboarding view controller to automatically move to the next page.
 */
- (void)moveNextPage;


// The following properties are all deprecated, and will be removed in the next release of Onboard.
//
//
@property (nonatomic) BOOL hidePageControl __attribute__((deprecated("Modify the pageControl property directly. This property will be removed in the next update.")));

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
@property (nonatomic) CGFloat bottomPadding __attribute__((deprecated("Modify the content view controller's bottomPadding directly. This property will be removed in the next update.")));

@end
