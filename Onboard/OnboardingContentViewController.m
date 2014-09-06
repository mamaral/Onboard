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
static CGFloat const kImageViewSize = 100;
static CGFloat const kVerticalPadding = 60;
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

    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _titleText = title;
    _body = body;
    _image = image;
    _buttonText = buttonText;
    _actionHandler = action ?: ^{};
    
    self.iconSize = kImageViewSize;
    self.fontName = kDefaultOnboardingFont;
    self.titleFontSize = kOnboardingTitleFontSize;
    self.bodyFontSize = kOnboardingBodyFontSize;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded we can generate the content
    [self generateView];
}

- (void)generateView {
    // we want our background to be clear so we can see through it to the image provided
    self.view.backgroundColor = [UIColor clearColor];
    
    // do some calculation for some common values we'll need, namely the width of the view,
    // the center of the width, and the content width we want to fill up, which is some
    // fraction of the view width we set in the multipler constant
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat horizontalCenter = viewWidth / 2;
    CGFloat contentWidth = viewWidth * kContentWidthMultiplier;
    
    // create the image view with the appropriate image, size, and center in on screen
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    [imageView setFrame:CGRectMake(horizontalCenter - (self.iconSize / 2), kVerticalPadding, self.iconSize, self.iconSize)];
    [self.view addSubview:imageView];
    
    // create and configure the main text label
    UILabel *mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultOnboardingPadding, CGRectGetMaxY(imageView.frame) + kDefaultOnboardingPadding, contentWidth, 0)];
    mainTextLabel.text = _titleText;
    mainTextLabel.textColor = [UIColor whiteColor];
    mainTextLabel.font = [UIFont fontWithName:self.fontName size:self.titleFontSize];
    mainTextLabel.numberOfLines = 0;
    mainTextLabel.textAlignment = NSTextAlignmentCenter;
    [mainTextLabel sizeToFit];
    mainTextLabel.center = CGPointMake(horizontalCenter, mainTextLabel.center.y);
    [self.view addSubview:mainTextLabel];
    
    // create and configure the sub text label
    UILabel *subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultOnboardingPadding, CGRectGetMaxY(mainTextLabel.frame) + kDefaultOnboardingPadding, contentWidth, 0)];
    subTextLabel.text = _body;
    subTextLabel.textColor = [UIColor whiteColor];
    subTextLabel.font = [UIFont fontWithName:self.fontName size:self.bodyFontSize];
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
    // simply call the provided action handler
    _actionHandler();
}

@end
