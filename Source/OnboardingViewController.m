//
//  OnboardingViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
@import AVFoundation;
@import Accelerate;

static CGFloat const kPageControlHeight = 35;
static CGFloat const kSkipButtonWidth = 100;
static CGFloat const kSkipButtonHeight = 44;
static CGFloat const kBackgroundMaskAlpha = 0.6;
static CGFloat const kDefaultBlurRadius = 20;
static CGFloat const kDefaultSaturationDeltaFactor = 1.8;

static NSString * const kSkipButtonText = @"Skip";


@interface OnboardingViewController ()

@property (nonatomic, strong) OnboardingContentViewController *currentPage;
@property (nonatomic, strong) OnboardingContentViewController *upcomingPage;

@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSURL *videoURL;

@end


@implementation OnboardingViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initializing with images

+ (instancetype)onboardWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents {
    return [[self alloc] initWithBackgroundImage:backgroundImage contents:contents];
 }

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents {
    self = [self initWithContents:contents];

    if (!self) {
        return nil;
    }

    self.backgroundImage = backgroundImage;
    
    return self;
}


#pragma mark - Initializing with video files

+ (instancetype)onboardWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents {
    return [[self alloc] initWithBackgroundVideoURL:backgroundVideoURL contents:contents];
}

- (instancetype)initWithBackgroundVideoURL:(NSURL *)backgroundVideoURL contents:(NSArray *)contents {
    self = [self initWithContents:contents];

    if (!self) {
        return nil;
    }

    self.videoURL = backgroundVideoURL;
    
    return self;
}


#pragma mark - Initialization

- (instancetype)initWithContents:(NSArray *)contents {
    self = [super init];

    if (!self) {
        return nil;
    }
    
    // Store the passed in view controllers array
    self.viewControllers = contents;
    
    // Set the default properties
    self.shouldMaskBackground = YES;
    self.shouldBlurBackground = NO;
    self.shouldFadeTransitions = NO;
    self.fadePageControlOnLastPage = NO;
    self.fadeSkipButtonOnLastPage = NO;
    self.swipingEnabled = YES;
    
    self.allowSkipping = NO;
    self.skipHandler = ^{};
    
    // Create the initial exposed components so they can be customized
    self.pageControl = [UIPageControl new];
    self.pageControl.numberOfPages = self.viewControllers.count;
    self.pageControl.userInteractionEnabled = NO;

    self.skipButton = [UIButton new];
    [self.skipButton setTitle:kSkipButtonText forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(handleSkipButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.skipButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    return self;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppEnteredForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // now that the view has loaded, we can generate the content
    [self generateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we have a video URL, start playing
    if (self.videoURL) {
        [self.player play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if ((self.player.rate != 0.0) && !self.player.error && self.stopMoviePlayerWhenDisappear) {
        [self.player pause];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.pageVC.view.frame = self.view.frame;
    self.moviePlayerController.view.frame = self.view.frame;
    self.skipButton.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - kSkipButtonWidth, CGRectGetMaxY(self.view.frame) - self.underPageControlPadding - kSkipButtonHeight, kSkipButtonWidth, kSkipButtonHeight);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - self.underPageControlPadding - kPageControlHeight, self.view.frame.size.width, kPageControlHeight);
}

- (void)generateView {
    // create our page view controller
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageVC.view.backgroundColor = [UIColor whiteColor];
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self.swipingEnabled ? self : nil;
    
    if (self.shouldBlurBackground) {
        [self blurBackground];
    }
    
    UIImageView *backgroundImageView;
    
    // create the background image view and set it to aspect fill so it isn't skewed
    if (self.backgroundImage) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        backgroundImageView.clipsToBounds = YES;
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [backgroundImageView setImage:self.backgroundImage];
        [self.view addSubview:backgroundImageView];
    }
    
    // as long as the shouldMaskBackground setting hasn't been set to NO, we want to
    // create a partially opaque view and add it on top of the image view, so that it
    // darkens it a bit for better contrast
    UIView *backgroundMaskView;
    if (self.shouldMaskBackground) {
        backgroundMaskView = [[UIView alloc] initWithFrame:self.pageVC.view.frame];
        backgroundMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kBackgroundMaskAlpha];
        [self.pageVC.view addSubview:backgroundMaskView];
    }

    // set ourself as the delegate on all of the content views, to handle fading
    // and auto-navigation
    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.delegate = self;
    }

    // set the initial current page as the first page provided
    _currentPage = [self.viewControllers firstObject];
    
    // more page controller setup
    [self.pageVC setViewControllers:@[self.currentPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageVC.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC didMoveToParentViewController:self];
    [self.pageVC.view sendSubviewToBack:backgroundMaskView];
    
    // send the background image view to the back if we have one
    if (backgroundImageView) {
        [self.pageVC.view sendSubviewToBack:backgroundImageView];
    }
    
    // otherwise send the video view to the back if we have one
    else if (self.videoURL) {
        self.player = [[AVPlayer alloc] initWithURL:self.videoURL];

        self.moviePlayerController = [AVPlayerViewController new];
        self.moviePlayerController.player = self.player;
        self.moviePlayerController.showsPlaybackControls = NO;
        
        [self.pageVC.view addSubview:self.moviePlayerController.view];
        [self.pageVC.view sendSubviewToBack:self.moviePlayerController.view];
    }
    
    // create the page control
    [self.view addSubview:self.pageControl];
    
    // if we allow skipping, setup the skip button
    if (self.allowSkipping) {
        [self.view addSubview:self.skipButton];
    }
    
    // if we want to fade the transitions, we need to tap into the underlying scrollview
    // so we can set ourself as the delegate, this is sort of hackish but the only current
    // solution I am aware of using a page view controller
    if (self.shouldFadeTransitions) {
        for (UIView *view in self.pageVC.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)view setDelegate:self];
            }
        }
    }
}


#pragma mark - App life cycle

- (void)handleAppEnteredForeground {
    // If we have a video URL, restart it as it will be paused when
    // the app enters the foreground.
    if (self.videoURL) {
        [self.player play];
    }
}


#pragma mark - Skipping

- (void)handleSkipButtonPressed {
    if (self.skipHandler) {
        self.skipHandler();
    }
}

- (void)setUnderPageControlPadding:(CGFloat)underPageControlPadding {
    _underPageControlPadding = underPageControlPadding;

    for (OnboardingContentViewController *contentVC in self.viewControllers) {
        contentVC.underPageControlPadding = underPageControlPadding;
    }
}

#pragma mark - Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // return the previous view controller in the array unless we're at the beginning
    if (viewController == [self.viewControllers firstObject]) {
        return nil;
    } else {
        NSInteger priorPageIndex = [self.viewControllers indexOfObject:viewController] - 1;
        return self.viewControllers[priorPageIndex];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // return the next view controller in the array unless we're at the end
    if (viewController == [self.viewControllers lastObject]) {
        return nil;
    } else {
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
        [self.pageVC setViewControllers:@[self.viewControllers[indexOfNextPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self.pageControl setCurrentPage:indexOfNextPage];
    }
}


#pragma mark - Onboarding content view controller delegate

- (void)setCurrentPage:(OnboardingContentViewController *)currentPage {
    _currentPage = currentPage;
}

- (void)setNextPage:(OnboardingContentViewController *)nextPage {
    _upcomingPage = nextPage;
}


#pragma mark - Page scroll status

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // calculate the percent complete of the transition of the current page given the
    // scrollview's offset and the width of the screen
    CGFloat percentComplete = fabs(scrollView.contentOffset.x - self.view.frame.size.width) / self.view.frame.size.width;
    CGFloat percentCompleteInverse = 1.0 - percentComplete;
    
    // these cases have some funky results given the way this method is called, like stuff
    // just disappearing, so we want to do nothing in these cases
    if (percentComplete == 0) {
        return;
    }

    // set the next page's alpha to be the percent complete, so if we're 90% of the way
    // scrolling towards the next page, its content's alpha should be 90%
    [_upcomingPage updateAlphas:percentComplete];
    
    // set the current page's alpha to the difference between 100% and this percent value,
    // so we're 90% scrolling towards the next page, the current content's alpha sshould be 10%
    [_currentPage updateAlphas:percentCompleteInverse];

    // determine if we're transitioning to or from our last page
    BOOL transitioningToLastPage = (_currentPage != self.viewControllers.lastObject && _upcomingPage == self.viewControllers.lastObject);
    BOOL transitioningFromLastPage = (_currentPage == self.viewControllers.lastObject) && (_upcomingPage == self.viewControllers[self.viewControllers.count - 2]);
    
    // fade the page control to and from the last page
    if (self.fadePageControlOnLastPage) {
        if (transitioningToLastPage) {
            self.pageControl.alpha = percentCompleteInverse;
        }

        else if (transitioningFromLastPage) {
            self.pageControl.alpha = percentComplete;
        }
    }

    // fade the skip button to and from the last page
    if (self.fadeSkipButtonOnLastPage) {
        if (transitioningToLastPage) {
            self.skipButton.alpha = percentCompleteInverse;
        }

        else if (transitioningFromLastPage) {
            self.skipButton.alpha = percentComplete;
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
