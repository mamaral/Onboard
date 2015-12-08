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

@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic, strong) NSURL *videoURL;

@end

@implementation OnboardingContentViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationWillEnterForegroundNotification];
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title body:body image:image buttonText:buttonText action:action];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    return [self initWithTitle:title body:body image:image buttonText:buttonText actionBlock:^(OnboardingViewController *onboardController) {
        if(action) action();
    }];
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title body:body image:image buttonText:buttonText actionBlock:actionBlock];
    return contentVC;
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title body:body videoURL:videoURL buttonText:buttonText action:action];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    return [self initWithTitle:title body:body image:nil videoURL:videoURL buttonText:buttonText actionBlock:^(OnboardingViewController *onboardController) {
        if(action) action();
    }];
}

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body videoURL:(NSURL *)videoURL  buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title body:body image:nil videoURL:videoURL buttonText:buttonText actionBlock:actionBlock];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    return [self initWithTitle:title body:body image:image videoURL:nil buttonText:buttonText actionBlock:actionBlock];
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image videoURL:(NSURL *)videoURL buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock {
    self = [super init];

    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _titleText = title;
    _body = body;
    _image = image;
    _buttonText = buttonText;
    self.videoURL = videoURL;

    self.buttonActionHandler = actionBlock;
    
    // default auto-navigation
    self.movesToNextViewController = NO;
    
    // default icon properties
    if(_image) {
		self.iconHeight = _image.size.height;
		self.iconWidth = _image.size.width;
	}
    
    else {
		self.iconHeight = kDefaultImageViewSize;
		self.iconWidth = kDefaultImageViewSize;
	}
    
    // default title properties
    self.titleFontName = kDefaultOnboardingFont;
    self.titleFontSize = kDefaultTitleFontSize;
    
    // default body properties
    self.bodyFontName = kDefaultOnboardingFont;
    self.bodyFontSize = kDefaultBodyFontSize;
    
    // default button properties
    self.buttonFontName = kDefaultOnboardingFont;
    self.buttonFontSize = kDefaultButtonFontSize;
    
    // default padding values
    self.topPadding = kDefaultTopPadding;
    self.underIconPadding = kDefaultUnderIconPadding;
    self.underTitlePadding = kDefaultUnderTitlePadding;
    self.bottomPadding = kDefaultBottomPadding;
    self.underPageControlPadding = kDefaultUnderPageControlPadding;
    
    // default colors
    self.titleTextColor = DEFAULT_TEXT_COLOR;
    self.bodyTextColor = DEFAULT_TEXT_COLOR;
    self.buttonTextColor = DEFAULT_TEXT_COLOR;
    
    // default blocks
    self.viewWillAppearBlock = ^{};
    self.viewDidAppearBlock = ^{};
    self.viewWillDisappearBlock = ^{};
    self.viewDidDisappearBlock = ^{};
    
    // Handle when the app enters the foreground.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded we can generate the content
    [self generateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we have a delegate set, mark ourselves as the next page now that we're
    // about to appear
    if (self.delegate) {
        [self.delegate setNextPage:self];
    }
    
    // call our view will appear block
    if (self.viewWillAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillAppearBlock();
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if we have a delegate set, mark ourselves as the current page now that
    // we've appeared
    if (self.delegate) {
        [self.delegate setCurrentPage:self];
    }
    
    // call our view did appear block
    if (self.viewDidAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidAppearBlock();
        });
    }
    
    // if we have a video, start playing
    if (self.moviePlayerController.playbackState != MPMoviePlaybackStatePlaying) {
        self.moviePlayerController.currentPlaybackTime = 0.0;
        [self.moviePlayerController play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // call our view will disappear block
    if (self.viewWillDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillDisappearBlock();
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // call our view did disappear block
    if (self.viewDidDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidDisappearBlock();
        });
    }
    
    // if we have a video, stop playing
    if (self.moviePlayerController.playbackState != MPMoviePlaybackStateStopped) {
        [self.moviePlayerController stop];
    }
}

- (void)setButtonActionHandler:(action_callback)actionBlock {
    _buttonActionHandler = actionBlock ?: ^(OnboardingViewController *controller){};
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
    
    if (_image) {
        
        // create the image view with the appropriate image, size, and center in on screen
        _imageView = [[UIImageView alloc] initWithImage:_image];
        [_imageView setFrame:CGRectMake(horizontalCenter - (self.iconWidth / 2), self.topPadding, self.iconWidth, self.iconHeight)];
        [self.view addSubview:_imageView];
    
    } else if (self.videoURL) {
        
        // or if we have a video create and configure the video player controller
        self.moviePlayerController = [MPMoviePlayerController new];
        self.moviePlayerController.contentURL = self.videoURL;
        self.moviePlayerController.view.frame = self.view.frame;
        self.moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
        
        UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:[self thumbnailImageForVideo:self.videoURL]];
        thumbnailImageView.frame = self.view.frame;
        thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.moviePlayerController.backgroundView addSubview:thumbnailImageView];
        
        [self.view addSubview:self.moviePlayerController.view];
    }
    
    // create and configure the main text label sitting underneath the icon with the provided padding
    _mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + self.underIconPadding, contentWidth, 0)];
    _mainTextLabel.accessibilityIdentifier = kOnboardMainTextAccessibilityIdentifier;
    _mainTextLabel.text = _titleText;
    _mainTextLabel.textColor = self.titleTextColor;
    _mainTextLabel.font = [UIFont fontWithName:self.titleFontName size:self.titleFontSize];
    _mainTextLabel.numberOfLines = 0;
    _mainTextLabel.textAlignment = NSTextAlignmentCenter;
    [_mainTextLabel sizeToFit];
    _mainTextLabel.center = CGPointMake(horizontalCenter, _mainTextLabel.center.y);
    [self.view addSubview:_mainTextLabel];
    
    // create and configure the sub text label
    _subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainTextLabel.frame) + self.underTitlePadding, contentWidth, 0)];
    _subTextLabel.accessibilityIdentifier = kOnboardSubTextAccessibilityIdentifier;
    _subTextLabel.text = _body;
    _subTextLabel.textColor = self.bodyTextColor;
    _subTextLabel.font = [UIFont fontWithName:self.bodyFontName size:self.bodyFontSize];
    _subTextLabel.numberOfLines = 0;
    _subTextLabel.textAlignment = NSTextAlignmentCenter;
    [_subTextLabel sizeToFit];
    _subTextLabel.center = CGPointMake(horizontalCenter, _subTextLabel.center.y);
    [self.view addSubview:_subTextLabel];
    
    // create the action button if we were given button text
    if (_buttonText) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentWidth / 2), CGRectGetMaxY(self.view.frame) - self.underPageControlPadding - kMainPageControlHeight - kActionButtonHeight - self.bottomPadding, contentWidth, kActionButtonHeight)];
        _actionButton.accessibilityIdentifier = kOnboardActionButtonAccessibilityIdentifier;
        _actionButton.titleLabel.font = [UIFont fontWithName:self.buttonFontName size:self.buttonFontSize];
        [_actionButton setTitle:_buttonText forState:UIControlStateNormal];
        [_actionButton setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_actionButton];
    }
}

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

- (void)handleAppEnteredForeground {
    //If the movie player is paused, as it does by default when backgrounded, start playing again.
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePaused) {
        [self.moviePlayerController play];
    }
}

#pragma mark - Transition alpha

- (void)updateAlphas:(CGFloat)newAlpha {
    _imageView.alpha = newAlpha;
    _mainTextLabel.alpha = newAlpha;
    _subTextLabel.alpha = newAlpha;
    _actionButton.alpha = newAlpha;
}

#pragma mark - action button callback

- (void)handleButtonPressed {
    // if we want to navigate to the next view controller, tell our delegate
    // to handle it
    if (self.movesToNextViewController) {
        [self.delegate moveNextPage];
    }
    
    // call the provided action handler
    if (_buttonActionHandler) {
        _buttonActionHandler(self.delegate);
    }
}

@end
