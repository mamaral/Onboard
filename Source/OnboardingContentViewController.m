//
//  OnboardingContentViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kDefaultOnboardingFont = @"Helvetica-Light";

#define DEFAULT_TEXT_COLOR [UIColor whiteColor];

static CGFloat const kContentWidthMultiplier = 0.9;
static CGFloat const kDefaultImageViewSize = 100;
static CGFloat const kDefaultTopPadding = 60;
static CGFloat const kDefaultUnderIconPadding = 30;
static CGFloat const kDefaultUnderTitlePadding = 30;
static CGFloat const kDefaultBottomPadding = 0;
static CGFloat const kDefaultUnderPageControlPadding = 0;
static CGFloat const kDefaultTitleFontSize = 38;
static CGFloat const kDefaultBodyFontSize = 28;
static CGFloat const kDefaultButtonFontSize = 24;

static CGFloat const kActionButtonHeight = 50;
static CGFloat const kMainPageControlHeight = 35;

NSString * const kOnboardMainTextAccessibilityIdentifier = @"OnboardMainTextAccessibilityIdentifier";
NSString * const kOnboardSubTextAccessibilityIdentifier = @"OnboardSubTextAccessibilityIdentifier";
NSString * const kOnboardActionButtonAccessibilityIdentifier = @"OnboardActionButtonAccessibilityIdentifier";

@interface OnboardingContentViewController ()

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation OnboardingContentViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    return [[self alloc] initWithTitle:title body:body image:image buttonText:buttonText action:action];
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    return [self initWithTitle:title body:body image:image buttonText:buttonText actionBlock:^(OnboardingViewController *onboardController) {
        if (action) {
            action();
        }
    }];
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    return [[self alloc] initWithTitle:title body:body image:image buttonText:buttonText actionBlock:actionBlock];
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    return [[self alloc] initWithTitle:title body:body videoURL:videoURL buttonText:buttonText action:action];
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    return [self initWithTitle:title body:body image:nil videoURL:videoURL buttonText:buttonText actionBlock:^(OnboardingViewController *onboardController) {
        if (action) {
            action();
        }
    }];
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    return [[self alloc] initWithTitle:title body:body image:nil videoURL:videoURL buttonText:buttonText actionBlock:actionBlock];
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    return [self initWithTitle:title body:body image:image videoURL:nil buttonText:buttonText actionBlock:actionBlock];
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image videoURL:(NSURL *)videoURL buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    self = [super init];

    if (self == nil) {
        return nil;
    }

    // Icon image view
    self.iconImageView = [[UIImageView alloc] initWithImage:image];
    self.iconWidth = image ? image.size.width : kDefaultImageViewSize;
    self.iconHeight = image ? image.size.height : kDefaultImageViewSize;

    // Title label
    self.titleLabel = [UILabel new];
    self.titleLabel.accessibilityIdentifier = kOnboardMainTextAccessibilityIdentifier;
    self.titleLabel.text = title;
    self.titleLabel.textColor = DEFAULT_TEXT_COLOR;
    self.titleLabel.font = [UIFont fontWithName:kDefaultOnboardingFont size:kDefaultTitleFontSize];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    // Body label
    self.bodyLabel = [UILabel new];
    self.bodyLabel.accessibilityIdentifier = kOnboardSubTextAccessibilityIdentifier;
    self.bodyLabel.text = body;
    self.bodyLabel.textColor = DEFAULT_TEXT_COLOR;
    self.bodyLabel.font = [UIFont fontWithName:kDefaultOnboardingFont size:kDefaultBodyFontSize];
    self.bodyLabel.numberOfLines = 0;
    self.bodyLabel.textAlignment = NSTextAlignmentCenter;

    // Action button
    self.actionButton = [UIButton new];
    self.actionButton.accessibilityIdentifier = kOnboardActionButtonAccessibilityIdentifier;
    self.actionButton.titleLabel.font = [UIFont fontWithName:kDefaultOnboardingFont size:kDefaultButtonFontSize];
    [self.actionButton setTitle:buttonText forState:UIControlStateNormal];
    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    self.buttonActionHandler = actionBlock ?: ^(OnboardingViewController *controller){};

    // Movie player
    if (videoURL) {
        self.videoURL = videoURL;

        self.moviePlayerController = [MPMoviePlayerController new];
        self.moviePlayerController.contentURL = self.videoURL;
        self.moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        self.moviePlayerController.controlStyle = MPMovieControlStyleNone;

        self.thumbnailImageView = [[UIImageView alloc] initWithImage:[self thumbnailImageForVideo:self.videoURL]];
        self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    // Auto-navigation
    self.movesToNextViewController = NO;
    
    // Default padding values
    self.topPadding = kDefaultTopPadding;
    self.underIconPadding = kDefaultUnderIconPadding;
    self.underTitlePadding = kDefaultUnderTitlePadding;
    self.bottomPadding = kDefaultBottomPadding;
    self.underPageControlPadding = kDefaultUnderPageControlPadding;
    
    // Default blocks
    self.viewWillAppearBlock = ^{};
    self.viewDidAppearBlock = ^{};
    self.viewWillDisappearBlock = ^{};
    self.viewDidDisappearBlock = ^{};
    
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Handle when the app enters the foreground.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

    self.view.backgroundColor = [UIColor clearColor];

    // Add all our subviews
    if (self.videoURL != nil) {
        [self.moviePlayerController.backgroundView addSubview:self.thumbnailImageView];
        [self.view addSubview:self.moviePlayerController.view];
    }

    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.bodyLabel];
    [self.view addSubview:self.actionButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // If we have a delegate set, mark ourselves as the next page now that we're
    // about to appear
    if (self.delegate) {
        [self.delegate setNextPage:self];
    }
    
    // Call our view will appear block
    if (self.viewWillAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillAppearBlock();
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // If we have a delegate set, mark ourselves as the current page now that
    // we've appeared
    if (self.delegate) {
        [self.delegate setCurrentPage:self];
    }
    
    // Call our view did appear block
    if (self.viewDidAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidAppearBlock();
        });
    }
    
    // If we have a video, start playing
    if (self.moviePlayerController.playbackState != MPMoviePlaybackStatePlaying) {
        self.moviePlayerController.currentPlaybackTime = 0.0;
        [self.moviePlayerController play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Call our view will disappear block
    if (self.viewWillDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillDisappearBlock();
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // Call our view did disappear block
    if (self.viewDidDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidDisappearBlock();
        });
    }
    
    // If we have a video, stop playing
    if (self.moviePlayerController.playbackState != MPMoviePlaybackStateStopped) {
        [self.moviePlayerController stop];
    }
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (self.videoURL) {
        self.moviePlayerController.view.frame = self.view.frame;
    }

    if (self.thumbnailImageView) {
        self.thumbnailImageView.frame = self.view.frame;
    }

    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat contentWidth = viewWidth * kContentWidthMultiplier;
    CGFloat xPadding = (viewWidth - contentWidth) / 2.0;

    [self.iconImageView setFrame:CGRectMake((viewWidth / 2.0) - (self.iconWidth / 2.0), self.topPadding, self.iconWidth, self.iconHeight)];

    CGFloat titleYOrigin = CGRectGetMaxY(self.iconImageView.frame) + self.underIconPadding;

    self.titleLabel.frame = CGRectMake(xPadding, titleYOrigin, contentWidth, 0);
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(xPadding, titleYOrigin, contentWidth, CGRectGetHeight(self.titleLabel.frame));

    CGFloat bodyYOrigin = CGRectGetMaxY(self.titleLabel.frame) + self.underTitlePadding;

    self.bodyLabel.frame = CGRectMake(xPadding, bodyYOrigin, contentWidth, 0);
    [self.bodyLabel sizeToFit];
    self.bodyLabel.frame = CGRectMake(xPadding, bodyYOrigin, contentWidth, CGRectGetHeight(self.bodyLabel.frame));

    self.actionButton.frame = CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentWidth / 2), CGRectGetMaxY(self.view.frame) - self.underPageControlPadding - kMainPageControlHeight - kActionButtonHeight - self.bottomPadding, contentWidth, kActionButtonHeight);
}


#pragma mark - App state

- (void)handleAppEnteredForeground {
    //If the movie player is paused, as it does by default when backgrounded, start playing again.
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePaused) {
        [self.moviePlayerController play];
    }
}


#pragma mark - Transition alpha

- (void)updateAlphas:(CGFloat)newAlpha {
    self.iconImageView.alpha = newAlpha;
    self.titleLabel.alpha = newAlpha;
    self.bodyLabel.alpha = newAlpha;
    self.actionButton.alpha = newAlpha;
}


#pragma mark - Action button stuff

- (void)handleButtonPressed {
    // if we want to navigate to the next view controller, tell our delegate
    // to handle it
    if (self.movesToNextViewController) {
        [self.delegate moveNextPage];
    }
    
    // call the provided action handler
    if (self.buttonActionHandler) {
        self.buttonActionHandler(self.delegate);
    }
}


#pragma mark - Utils

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL {

    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *assetIG = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

    NSError *error = nil;
    CGImageRef thumbnailImageRef = [assetIG copyCGImageAtTime:CMTimeMake(0, 60) actualTime:NULL error:&error];

    if (!error) {
        UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
        return thumbnailImage;
    } else {
        NSLog(@"thumbnailImageGenerationError %@", error);
        return nil;
    }
}

@end
