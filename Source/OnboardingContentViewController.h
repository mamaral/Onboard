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

extern NSString * const kOnboardMainTextAccessibilityIdentifier;
extern NSString * const kOnboardSubTextAccessibilityIdentifier;
extern NSString * const kOnboardActionButtonAccessibilityIdentifier;

typedef void (^action_callback)(OnboardingViewController *onboardController);

@interface OnboardingContentViewController : UIViewController {
    NSAttributedString *_attributedTitleText;
    NSAttributedString *_attributedBody;
    UIImage *_image;
    NSAttributedString *_attributedButtonText;

    UIImageView *_imageView;
    UILabel *_mainTextLabel;
    UILabel *_subTextLabel;
    UIButton *_actionButton;
}

@property (nonatomic) OnboardingViewController *delegate;

@property (nonatomic) BOOL movesToNextViewController;

@property (nonatomic) CGFloat iconHeight;
@property (nonatomic) CGFloat iconWidth;

@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIColor *bodyTextColor;
@property (nonatomic, strong) UIColor *buttonTextColor;

@property (nonatomic, strong) NSString *titleFontName;
@property (nonatomic) CGFloat titleFontSize;

@property (nonatomic, strong) NSString *bodyFontName;
@property (nonatomic) CGFloat bodyFontSize;

@property (nonatomic, strong) NSString *buttonFontName;
@property (nonatomic) CGFloat buttonFontSize;

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

// Non-attributed text, image, dispatch block
+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action;
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action;

// Non-attributed text, image, action callback
+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;

// Non-attributed text, video, dispatch block
+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL buttonText:(NSString *)buttonText action:(dispatch_block_t)action;
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText action:(dispatch_block_t)action;

// Non-attributed text, video, action callback
+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;

// Non-attributed text, image and video, action callback
- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image videoURL:videoURL buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock;

// Attributed text, image, dispatch block
+ (instancetype)contentWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody image:(UIImage *)image attributedButtonText:(NSAttributedString *)attributedButtonText action:(dispatch_block_t)action;
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody image:(UIImage *)image attributedButtonText:(NSAttributedString *)attributedButtonText action:(dispatch_block_t)action;

// Attributed text, image, action callback
+ (instancetype)contentWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody image:(UIImage *)image attributedButtonText:(NSAttributedString *)attributedButtonText actionBlock:(action_callback)actionBlock;
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody image:(UIImage *)image attributedButtonText:(NSAttributedString *)attributedButtonText actionBlock:(action_callback)actionBlock;

// Attributed text, video, dispatch block
+ (instancetype)contentWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody videoURL:(NSURL *)videoURL attributedButtonText:(NSAttributedString *)attributedButtonText action:(dispatch_block_t)action;
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody videoURL:(NSURL *)videoURL  attributedButtonText:(NSAttributedString *)attributedButtonText action:(dispatch_block_t)action;

// Attributed text, video, action callback
+ (instancetype)contentWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody videoURL:(NSURL *)videoURL  attributedButtonText:(NSAttributedString *)attributedButtonText actionBlock:(action_callback)actionBlock;
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody videoURL:(NSURL *)videoURL  attributedButtonText:(NSAttributedString *)attributedButtonText actionBlock:(action_callback)actionBlock;

// Attributed text, image and video, action callback
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedBody:(NSAttributedString *)attributedBody image:(UIImage *)image videoURL:videoURL attributedButtonText:(NSAttributedString *)attributedButtonText actionBlock:(action_callback)actionBlock;

- (void)updateAlphas:(CGFloat)newAlpha;

@end
