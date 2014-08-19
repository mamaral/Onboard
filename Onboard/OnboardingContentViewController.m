//
//  OnboardingContentViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingContentViewController.h"

static NSString * const kDefaultOnboardingFont = @"Helvetica-Light";

static CGFloat const kContentWidthMultiplier = 0.9;
static CGFloat const kDefaultOnboardingPadding = 20;
static CGFloat const kOnboardingTitleFontSize = 38;
static CGFloat const kOnboardingBodyFontSize = 28;
static CGFloat const kActionButtonHeight = 50;
static CGFloat const kMainPageControlHeight = 35;

@interface OnboardingContentViewController ()

@end

@implementation OnboardingContentViewController

- (id)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    self = [super init];

    _titleText = title;
    _body = body;
    _image = image;
    _buttonText = buttonText;
    _actionHandler = action ?: ^{};
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateView];
}

- (void)generateView {
    self.view.backgroundColor = [UIColor clearColor];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat horizontalCenter = viewWidth / 2;
    CGFloat contentWidth = viewWidth * kContentWidthMultiplier;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    [imageView setFrame:CGRectMake((viewWidth / 2) - (100 / 2), 4 * kDefaultOnboardingPadding , 100, 100)];
    [self.view addSubview:imageView];
    
    UILabel *mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultOnboardingPadding, CGRectGetMaxY(imageView.frame) + kDefaultOnboardingPadding, contentWidth, 0)];
    mainTextLabel.text = _titleText;
    mainTextLabel.textColor = [UIColor whiteColor];
    mainTextLabel.font = [UIFont fontWithName:kDefaultOnboardingFont size:kOnboardingTitleFontSize];
    mainTextLabel.numberOfLines = 0;
    mainTextLabel.textAlignment = NSTextAlignmentCenter;
    [mainTextLabel sizeToFit];
    mainTextLabel.center = CGPointMake(horizontalCenter, mainTextLabel.center.y);
    [self.view addSubview:mainTextLabel];
    
    UILabel *subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultOnboardingPadding, CGRectGetMaxY(mainTextLabel.frame) + kDefaultOnboardingPadding, contentWidth, 0)];
    subTextLabel.text = _body;
    subTextLabel.textColor = [UIColor whiteColor];
    subTextLabel.font = [UIFont fontWithName:kDefaultOnboardingFont size:kOnboardingBodyFontSize];
    subTextLabel.numberOfLines = 0;
    subTextLabel.textAlignment = NSTextAlignmentCenter;
    [subTextLabel sizeToFit];
    subTextLabel.center = CGPointMake(horizontalCenter, subTextLabel.center.y);
    [self.view addSubview:subTextLabel];
    
    // create the action button if we were given button text
    if (_buttonText) {
        UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentWidth / 2), CGRectGetMaxY(self.view.frame) - kMainPageControlHeight - kActionButtonHeight - kDefaultOnboardingPadding, contentWidth, kActionButtonHeight)];
        actionButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [actionButton setTitle:_buttonText forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:actionButton];
    }
}

#pragma mark - action button callback

- (void)handleButtonPressed {
    _actionHandler();
}

@end
