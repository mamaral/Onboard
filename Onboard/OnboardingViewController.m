//
//  OnboardingViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"

static CGFloat const kPageControlHeight = 35;
static CGFloat const kBackgroundMaskAlpha = 0.6;

@implementation OnboardingViewController

- (id)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents {
    self = [super init];

    // store the passed in backgroujd image and view controllers array
    _backgroundImage = backgroundImage;
    _viewControllers = contents;
    
    // we want the background masked by default
    _shouldMaskBackground = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded, we can generate the content
    [self generateView];
}

- (void)generateView {
    // create our page view controller
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = self.view.frame;
    _pageVC.view.backgroundColor = [UIColor whiteColor];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    
    // create the background image view and set it to aspect fill so it isn't skewed
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backgroundImageView setImage:_backgroundImage];
    [self.view addSubview:backgroundImageView];
    
    // as long as the shouldMaskBackground setting hasn't been set to NO, we want to
    // create a partially opaque view and add it on top of the image view, so that it
    // darkens it a bit for better contrast
    UIView *backgroundMaskView;
    if (self.shouldMaskBackground) {
        backgroundMaskView = [[UIView alloc] initWithFrame:_pageVC.view.frame];
        backgroundMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kBackgroundMaskAlpha];
        [_pageVC.view addSubview:backgroundMaskView];
    }
    
    // more page controller setup
    [_pageVC setViewControllers:@[[_viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _pageVC.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    [_pageVC didMoveToParentViewController:self];
    [_pageVC.view sendSubviewToBack:backgroundMaskView];
    [_pageVC.view sendSubviewToBack:backgroundImageView];
    
    // create and configure the the page control
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - kPageControlHeight, self.view.frame.size.width, kPageControlHeight)];
    _pageControl.numberOfPages = _viewControllers.count;
    [self.view addSubview:_pageControl];
}


#pragma mark - Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // return the previous view controller unless we're at the beginning of the list
    if (viewController == [_viewControllers firstObject]) {
        return nil;
    }
    else {
        NSInteger priorPageIndex = [_viewControllers indexOfObject:viewController] - 1;
        return _viewControllers[priorPageIndex];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // return the next view controller in the array unless we're at the end of the list
    if (viewController == [_viewControllers lastObject]) {
        return nil;
    }
    else {
        NSInteger nextPageIndex = [_viewControllers indexOfObject:viewController] + 1;
        return _viewControllers[nextPageIndex];
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
    NSInteger newIndex = [_viewControllers indexOfObject:viewController];
    [_pageControl setCurrentPage:newIndex];
}

- (void)moveToPageForViewController:(UIViewController *)viewController {
    [_pageVC setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [_pageControl setCurrentPage:[_viewControllers indexOfObject:viewController]];
}


@end
