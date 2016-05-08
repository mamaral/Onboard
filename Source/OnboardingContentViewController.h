//
//  OnboardingContentViewController.h
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MediaPlayer;

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

@property (nonatomic) BOOL movesToNextViewController;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic) CGFloat iconHeight;
@property (nonatomic) CGFloat iconWidth;
@property (nonatomic) CGFloat topPadding;
@property (nonatomic) CGFloat underIconPadding;
@property (nonatomic) CGFloat underTitlePadding;
@property (nonatomic) CGFloat bottomPadding;
@property (nonatomic) CGFloat underPageControlPadding;

@property (nonatomic, copy) action_callback buttonActionHandler;

@property (nonatomic, copy) dispatch_block_t viewWillAppearBlock;
@property (nonatomic, copy) dispatch_block_t viewDidAppearBlock;
@property (nonatomic, copy) dispatch_block_t viewWillDisappearBlock;
@property (nonatomic, copy) dispatch_block_t viewDidDisappearBlock;


@property (nonatomic, strong) UIColor *titleTextColor __attribute__((deprecated("Set titleLabel.textColor instead.")));
@property (nonatomic, strong) NSString *titleFontName __attribute__((deprecated("Set titleLabel.font instead.")));
@property (nonatomic) CGFloat titleFontSize __attribute__((deprecated("Set titleLabel.font instead.")));

@property (nonatomic, strong) UIColor *bodyTextColor __attribute__((deprecated("Set bodyLabel.textColor instead.")));
@property (nonatomic, strong) NSString *bodyFontName __attribute__((deprecated("Set bodyLabel.font instead.")));
@property (nonatomic) CGFloat bodyFontSize __attribute__((deprecated("Set bodyLabel.font instead.")));

@property (nonatomic, strong) UIColor *buttonTextColor __attribute__((deprecated("Modify the actionButton property directly.")));
@property (nonatomic, strong) NSString *buttonFontName __attribute__((deprecated("Modify the actionButton property directly.")));
@property (nonatomic) CGFloat buttonFontSize __attribute__((deprecated("Modify the actionButton property directly.")));


+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action;
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action;
+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL buttonText:(NSString *)buttonText action:(dispatch_block_t)action;
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText action:(dispatch_block_t)action;
+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image videoURL:videoURL buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;

- (void)updateAlphas:(CGFloat)newAlpha;

@end
