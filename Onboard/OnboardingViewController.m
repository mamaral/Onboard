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

@implementation OnboardingViewController

- (id)initWithBackgroundImage:(UIImage *)backgroundImage contents:(NSArray *)contents {
    self = [super init];

    _backgroundImage = backgroundImage;
    _viewControllers = contents;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self generateView];
}

- (void)generateView {
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = self.view.frame;
    _pageVC.view.backgroundColor = [UIColor whiteColor];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backgroundImageView setImage:_backgroundImage];
    [self.view addSubview:backgroundImageView];
    
    // this view will sit between the image and the buttons that sit on top to darken it a bit
    UIView *backgroundMaskView = [[UIView alloc] initWithFrame:_pageVC.view.frame];
    backgroundMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [_pageVC.view addSubview:backgroundMaskView];
    
    [_pageVC setViewControllers:@[[_viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _pageVC.view.backgroundColor = [UIColor clearColor];
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    [_pageVC didMoveToParentViewController:self];
    [_pageVC.view sendSubviewToBack:backgroundMaskView];
    [_pageVC.view sendSubviewToBack:backgroundImageView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - kPageControlHeight, self.view.frame.size.width, kPageControlHeight)];
    _pageControl.numberOfPages = _viewControllers.count;
    [self.view addSubview:_pageControl];
}


#pragma mark - Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == [_viewControllers lastObject]) {
        return nil;
    }
    else {
        NSInteger nextPageIndex = [_viewControllers indexOfObject:viewController] + 1;
        return _viewControllers[nextPageIndex];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == [_viewControllers firstObject]) {
        return nil;
    }
    else {
        NSInteger priorPageIndex = [_viewControllers indexOfObject:viewController] - 1;
        return _viewControllers[priorPageIndex];
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
