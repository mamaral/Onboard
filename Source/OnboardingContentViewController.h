//
//  OnboardingContentViewController.h
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVKit;

NS_ASSUME_NONNULL_BEGIN

@class OnboardingViewController;
@class OnboardingContentViewController;

@protocol OnboardingContentViewControllerDelegate <NSObject>

@required
- (void)setNextPage:(OnboardingContentViewController *)contentVC;
- (void)setCurrentPage:(OnboardingContentViewController *)contentVC;

@end

extern NSString * const kOnboardMainTextAccessibilityIdentifier;
extern NSString * const kOnboardSubTextAccessibilityIdentifier;
extern NSString * const kOnboardActionButtonAccessibilityIdentifier;

typedef void (^action_callback)(OnboardingViewController *onboardController);


@interface OnboardingContentViewController : UIViewController

@property (nonatomic, weak) OnboardingViewController<OnboardingContentViewControllerDelegate> *delegate;

/**
 * @brief Determines if the next page is automatically shown when the action button is pressed.
 */
@property (nonatomic) BOOL movesToNextViewController;


/**
 * @brief The image view used to show the top icon.
 */
@property (nonatomic, strong) UIImageView *iconImageView;


/**
 * @brief The title label.
 */
@property (nonatomic, strong) UILabel *titleLabel;


/**
 * @brief The body label.
 */
@property (nonatomic, strong) UILabel *bodyLabel;


/**
 * @brief The button used to call the action handler if one was provided.
 */
@property (nonatomic, strong) UIButton *actionButton;


/**
 * @brief The width of the icon image view.
 */
@property (nonatomic) CGFloat iconWidth;


/**
 * @brief The height of the icon image view.
 */
@property (nonatomic) CGFloat iconHeight;


/**
 * @brief The padding between the top of the screen and the top of the icon image view.
 */
@property (nonatomic) CGFloat topPadding;


/**
 * @brief The padding between the icon image view and the title label.
 */
@property (nonatomic) CGFloat underIconPadding;


/**
 * @brief The padding between the title label and the body label;
 */
@property (nonatomic) CGFloat underTitlePadding;


/**
 * @brief The padding between the bottom of the action button and the page control.
 */
@property (nonatomic) CGFloat bottomPadding;


/**
 * @brief The padding between the bottom of the screen and the page control.
 */
@property (nonatomic) CGFloat underPageControlPadding;


/**
 * @brief The block executed when the action button is pressed.
 */
@property (nonatomic, copy) action_callback buttonActionHandler;


/**
 * @brief The block executed when the content view controller's viewWillAppear method is called.
 */
@property (nonatomic, copy) dispatch_block_t viewWillAppearBlock;


/**
 * @brief The block executed when the content view controller's viewDidAppear method is called.
 */
@property (nonatomic, copy) dispatch_block_t viewDidAppearBlock;


/**
 * @brief The block executed when the content view controller's viewWillDisappear method is called.
 */
@property (nonatomic, copy) dispatch_block_t viewWillDisappearBlock;


/**
 * @brief The block executed when the content view controller's viewDidDisappear method is called.
 */
@property (nonatomic, copy) dispatch_block_t viewDidDisappearBlock;


/**
 * @brief The movie player controller used to play background movies.
 */
@property (nonatomic, strong) AVPlayerViewController *moviePlayerController;

NS_ASSUME_NONNULL_END

/**
 * @brief Convenience class initializer for creating an onboarding content view controller.
 * @return An instance of OnboardingViewController with the provided information.
 */
+ (nonnull instancetype)contentWithTitle:(nullable NSString *)title body:(nullable NSString *)body image:(nullable UIImage *)image buttonText:(nullable NSString *)buttonText action:(nullable dispatch_block_t)action;


/**
 * @brief Initializer for creating an onboarding content view controller.
 * @return An instance of OnboardingViewController with the provided information.
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title body:(nullable NSString *)body image:(nullable UIImage *)image buttonText:(nullable NSString *)buttonText action:(nullable dispatch_block_t)action;


/**
 * @brief Convenience class initializer for creating an onboarding content view controller with an action_callback block.
 * @return An instance of OnboardingViewController with the provided information.
 */
+ (nonnull instancetype)contentWithTitle:(nullable NSString *)title body:(nullable NSString *)body image:(nullable UIImage *)image buttonText:(nullable NSString *)buttonText actionBlock:(nullable action_callback)actionBlock;


/**
 * @brief Convenience class initializer for creating an onboarding content view controller with a video.
 * @return An instance of OnboardingViewController with the provided information.
 */
+ (nonnull instancetype)contentWithTitle:(nullable NSString *)title body:(nullable NSString *)body videoURL:(nullable NSURL *)videoURL buttonText:(nullable NSString *)buttonText action:(nullable dispatch_block_t)action;


/**
 * @brief Initializer for creating an onboarding content view controller with a video.
 * @return An instance of OnboardingViewController with the provided information.
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title body:(nullable NSString *)body videoURL:(nullable NSURL *)videoURL buttonText:(nullable NSString *)buttonText action:(nullable dispatch_block_t)action;


/**
 * @brief Convenience class initializer for creating an onboarding content view controller with a video and an action_callback block.
 * @return An instance of OnboardingViewController with the provided information.
 */
+ (nonnull instancetype)contentWithTitle:(nullable NSString *)title body:(nullable NSString *)body videoURL:(nullable NSURL *)videoURL buttonText:(nullable NSString *)buttonText actionBlock:(nullable action_callback)actionBlock;


/**
 * @brief Initializer for creating an onboarding content view controller with a video and an action_callback block.
 * @return An instance of OnboardingViewController with the provided information.
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title body:(nullable NSString *)body image:(nullable UIImage *)image buttonText:(nullable NSString *)buttonText actionBlock:(nullable action_callback)actionBlock;


/**
 * @brief Initializer for creating an onboarding content view controller with a video and an action_callback block.
 * @return An instance of OnboardingViewController with the provided information.
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title body:(nullable NSString *)body image:(nullable UIImage *)image videoURL:(nullable NSURL *)videoURL buttonText:(nullable NSString *)buttonText actionBlock:(nullable action_callback)actionBlock;


/**
 * @brief Method used to update the alpha value for all floating subviews (image, title, body, etc.)
 */
- (void)updateAlphas:(CGFloat)newAlpha;

@end
