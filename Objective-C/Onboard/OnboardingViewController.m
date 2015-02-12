//
//  OnboardingViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
@import Accelerate;

static CGFloat const kPageControlHeight = 35;
static CGFloat const kSkipButtonWidth = 100;
static CGFloat const kSkipButtonHeight = 44;
static CGFloat const kBackgroundMaskAlpha = 0.6;
static CGFloat const kDefaultBlurRadius = 20;
static CGFloat const kDefaultSaturationDeltaFactor = 1.8;

static NSString * const kSkipButtonText = @"Skip";

@implementation OnboardingViewController {
    NSURL *_videoURL;
    UIPageViewController *_pageVC;
    
    OnboardingContentViewController *_currentPage;
    OnboardingContentViewController *_upcomingPage;
}


#pragma mark - Initializing with images

+ (instancetype)onboardWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents {
     OnboardingViewController *onboardingVC = [[self alloc] initWithBackgroundImage:backgroundImage contents:contents];
     return onboardingVC;
 }

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents {
    self = [self initWithContents:contents];
    
    // store the passed in view controllers array
    self.backgroundImage = backgroundImage;
    
    return self;
}


#pragma mark - Initializing with video files

+ (instancetype)onboardWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents {
    OnboardingViewController *onboardingVC = [[self alloc] initWithBackgroundVideoURL:backgroundVideoURL contents:contents];
    return onboardingVC;
}

- (instancetype)initWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents {
    self = [self initWithContents:contents];
    
    // store the passed in video URL
    _videoURL = backgroundVideoURL;
    
    return self;
}


#pragma mark - Initialization

- (instancetype)initWithContents:(NSArray *)contents {
    self = [super init];
    
    // store the passed in view controllers array
    self.viewControllers = contents;
    
    // set the default properties
    self.shouldMaskBackground = YES;
    self.shouldBlurBackground = NO;
    self.shouldFadeTransitions = NO;
    self.fadePageControlOnLastPage = NO;
    self.swipingEnabled = YES;
    self.hidePageControl = NO;
    
    self.allowSkipping = NO;
    self.skipHandler = ^{};
    
    // create the initial exposed components so they can be customized
    self.pageControl = [UIPageControl new];
    self.skipButton = [UIButton new];
    
    // create the movie player controller
    self.moviePlayerController = [MPMoviePlayerController new];
    
    // Handle when the app enters the foreground.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded, we can generate the content
    [self generateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we have a video URL, start playing
    if (_videoURL) {
        [self.moviePlayerController play];
    }
}

- (void)generateView {
    // create our page view controller
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = self.view.frame;
    _pageVC.view.backgroundColor = [UIColor whiteColor];
    _pageVC.delegate = self;
    _pageVC.dataSource = self.swipingEnabled ? self : nil;
    
    if (self.shouldBlurBackground) {
        [self blurBackground];
    }
    
    UIImageView *backgroundImageView;
    
    // create the background image view and set it to aspect fill so it isn't skewed
    if (self.backgroundImage) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [backgroundImageView setImage:self.backgroundImage];
        [self.view addSubview:backgroundImageView];
    }
    
    // as long as the shouldMaskBackground setting hasn't been set to NO, we want to
    // create a partially opaque view and add it on top of the image view, so that it
    // darkens it a bit for better contrast
    UIView *backgroundMaskView;
    if (self.shouldMaskBackground) {
        backgroundMaskView = [[UIView alloc] initWithFrame:_pageVC.view.frame];
        backgroundMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kBackgroundMaskAlpha];
        [_pageVC.view addSubview:backgroundMaskView];
    }
    
    // set the initial current page as the first page provided
    _currentPage = [self.viewControllers firstObject];
    
    // more page controller setup
    [_pageVC setViewControllers:@[_currentPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _pageVC.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    [_pageVC didMoveToParentViewController:self];
    [_pageVC.view sendSubviewToBack:backgroundMaskView];
    
    // send the background image view to the back if we have one
    if (backgroundImageView) {
        [_pageVC.view sendSubviewToBack:backgroundImageView];
    }
    
    // otherwise send the video view to the back if we have one
    else if (_videoURL) {
        self.moviePlayerController.contentURL = _videoURL;
        self.moviePlayerController.view.frame = _pageVC.view.frame;
        self.moviePlayerController.repeatMode = MPMovieRepeatModeOne;
        self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
        
        [_pageVC.view addSubview:self.moviePlayerController.view];
        [_pageVC.view sendSubviewToBack:self.moviePlayerController.view];
    }
    
    // create and configure the the page control
    if (!self.hidePageControl) {
        self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - kPageControlHeight, self.view.frame.size.width, kPageControlHeight);
        self.pageControl.numberOfPages = self.viewControllers.count;
        self.pageControl.userInteractionEnabled = NO;
        [self.view addSubview:self.pageControl];
    }
    
    // if we allow skipping, setup the skip button
    if (self.allowSkipping) {
        self.skipButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - kSkipButtonWidth, CGRectGetMaxY(self.view.frame) - kSkipButtonHeight, kSkipButtonWidth, kSkipButtonHeight);
        [self.skipButton setTitle:kSkipButtonText forState:UIControlStateNormal];
        [self.skipButton addTarget:self action:@selector(handleSkipButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.skipButton];
    }
    
    // if we want to fade the transitions, we need to tap into the underlying scrollview
    // so we can set ourself as the delegate, this is sort of hackish but the only current
    // solution I am aware of using a page view controller
    if (self.shouldFadeTransitions) {
        for (UIView *view in _pageVC.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)view setDelegate:self];
            }
        }
    }
    
    // set ourself as the delegate on all of the content views, to handle fading
    // and auto-navigation
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.delegate = self;
    }
}

- (void)handleAppEnteredForeground {
    // If the movie player is paused, as it does by default when backgrounded, start
    // playing again.
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePaused) {
        [self.moviePlayerController play];
    }
}


#pragma mark - Skipping

- (void)handleSkipButtonPressed {
    self.skipHandler();
}


#pragma mark - Convenience setters for content pages

- (void)setIconSize:(CGFloat)iconSize {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.iconWidth = iconSize;
        contentVC.iconHeight = iconSize;
    }
}

- (void)setIconWidth:(CGFloat)iconWidth {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.iconWidth = iconWidth;
    }
}

- (void)setIconHeight:(CGFloat)iconHeight {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.iconHeight = iconHeight;
    }
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.titleTextColor = titleTextColor;
    }
}

- (void)setBodyTextColor:(UIColor *)bodyTextColor {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.bodyTextColor = bodyTextColor;
    }
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.buttonTextColor = buttonTextColor;
    }
}

- (void)setFontName:(NSString *)fontName {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.titleFontName = fontName;
        contentVC.bodyFontName = fontName;
        contentVC.buttonFontName = fontName;
    }
}

- (void)setTitleFontName:(NSString *)fontName {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.titleFontName = fontName;
    }
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.titleFontSize = titleFontSize;
    }
}

- (void)setBodyFontName:(NSString *)fontName {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.bodyFontName = fontName;
    }
}

- (void)setBodyFontSize:(CGFloat)bodyFontSize {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.bodyFontSize = bodyFontSize;
    }
}

- (void)setButtonFontName:(NSString *)fontName {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.buttonFontName = fontName;
    }
}

- (void)setButtonFontSize:(CGFloat)bodyFontSize {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.buttonFontSize = bodyFontSize;
    }
}

- (void)setTopPadding:(CGFloat)topPadding {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.topPadding = topPadding;
    }
}

- (void)setUnderIconPadding:(CGFloat)underIconPadding {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.underIconPadding = underIconPadding;
    }
}

- (void)setUnderTitlePadding:(CGFloat)underTitlePadding {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.underTitlePadding = underTitlePadding;
    }
}

- (void)setBottomPadding:(CGFloat)bottomPadding {
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.bottomPadding = bottomPadding;
    }
}


#pragma mark - Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // return the previous view controller in the array unless we're at the beginning
    if (viewController == [self.viewControllers firstObject]) {
        return nil;
    }
    else {
        NSInteger priorPageIndex = [self.viewControllers indexOfObject:viewController] - 1;
        return self.viewControllers[priorPageIndex];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // return the next view controller in the array unless we're at the end
    if (viewController == [self.viewControllers lastObject]) {
        return nil;
    }
    else {
        NSInteger nextPageIndex = [_viewControllers indexOfObject:viewController] + 1;
        return self.viewControllers[nextPageIndex];
    }
}


#pragma mark - Page view controller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    // if we haven't completed animating yet, we don't want to do anything because it could be cancelled
    if (!completed) {
        return;
    }
    
    // get the view controller we are moving towards, then get the index, then set it as the current page
    // for the page control dots
    UIViewController *viewController = [pageViewController.viewControllers lastObject];
    NSInteger newIndex = [self.viewControllers indexOfObject:viewController];
    [self.pageControl setCurrentPage:newIndex];
}

- (void)moveNextPage {
    NSUInteger indexOfNextPage = [self.viewControllers indexOfObject:_currentPage] + 1;
    
    if (indexOfNextPage < self.viewControllers.count) {
        [_pageVC setViewControllers:@[self.viewControllers[indexOfNextPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self.pageControl setCurrentPage:indexOfNextPage];
    }
}


#pragma mark - Page scroll status

- (void)setCurrentPage:(OnboardingContentViewController *)currentPage {
    _currentPage = currentPage;
}

- (void)setNextPage:(OnboardingContentViewController *)nextPage {
    _upcomingPage = nextPage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // calculate the percent complete of the transition of the current page given the
    // scrollview's offset and the width of the screen
    CGFloat percentComplete = fabs(scrollView.contentOffset.x - self.view.frame.size.width) / self.view.frame.size.width;
    
    // these cases have some funk results given the way this method is called, like stuff
    // just disappearing, so we want to do nothing in these cases
    if (_upcomingPage == _currentPage || percentComplete == 0) {
        return;
    }
    
    // set the next page's alpha to be the percent complete, so if we're 90% of the way
    // scrolling towards the next page, its content's alpha should be 90%
    [_upcomingPage updateAlphas:percentComplete];
    
    // set the current page's alpha to the difference between 100% and this percent value,
    // so we're 90% scrolling towards the next page, the current content's alpha sshould be 10%
    [_currentPage updateAlphas:1.0 - percentComplete];
    
    // If we want to fade the page control on the last page...
    if (self.fadePageControlOnLastPage) {
        // If the upcoming page is the last object, fade the page control out as we scroll.
        if (_upcomingPage == [self.viewControllers lastObject]) {
            _pageControl.alpha = 1.0 - percentComplete;
        }
        
        // Otherwise if we're on the last page and we're moving towards the second-to-last page, fade it back in.
        else if ((_currentPage == [self.viewControllers lastObject]) && (_upcomingPage == self.viewControllers[self.viewControllers.count - 2])) {
            _pageControl.alpha = percentComplete;
        }
    }
}


#pragma mark - Image blurring

- (void)blurBackground {
    // Check pre-conditions.
    if (self.backgroundImage.size.width < 1 || self.backgroundImage.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.backgroundImage.size.width, self.backgroundImage.size.height, self.backgroundImage);
        return;
    }
    if (!self.backgroundImage.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self.backgroundImage);
        return;
    }
    
    UIColor *tintColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    CGFloat blurRadius = kDefaultBlurRadius;
    CGFloat saturationDeltaFactor = kDefaultSaturationDeltaFactor;
    CGRect imageRect = { CGPointZero, self.backgroundImage.size };
    UIImage *effectImage = self.backgroundImage;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.backgroundImage.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.backgroundImage.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.backgroundImage.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.backgroundImage.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            unsigned int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.backgroundImage.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.backgroundImage.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.backgroundImage.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.backgroundImage = outputImage;
}

@end
