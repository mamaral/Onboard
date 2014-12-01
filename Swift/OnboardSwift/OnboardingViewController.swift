//
//  OnboardingViewController.swift
//  OnboardSwift
//
//  Created by Mike on 9/12/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
    let pageControl: UIPageControl = UIPageControl()
    let kPageControlHeight: CGFloat = 35
    let kBackgroundMaskAlpha: CGFloat = 0.6
    var backgroundImage: UIImage?
    var contents: [OnboardingContentViewController] = []
    var shouldMaskBackground: Bool = true
    
    init(backgroundImage: UIImage?, contents: [OnboardingContentViewController]) {
        self.backgroundImage = backgroundImage
        self.contents = contents
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        
        generateView()
    }
    
    func generateView() {
        pageViewController.delegate = self
        pageViewController.dataSource = self;
        pageViewController.view.frame = self.view.frame;
        
        // create the background image view and set it to aspect fill so it isn't skewed
        var backgroundImageView: UIImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = self.view.frame
        backgroundImageView.contentMode = .ScaleAspectFit
        self.view.addSubview(backgroundImageView)
        
        var backgroundMaskView = UIView()
        if shouldMaskBackground {
            backgroundMaskView = UIView(frame: self.view.frame)
            backgroundMaskView.backgroundColor = UIColor(white: 0.0, alpha: kBackgroundMaskAlpha)
            self.view.addSubview(backgroundMaskView)
        }
        
        
        pageViewController.setViewControllers([contents[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        pageViewController.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        pageViewController.view.sendSubviewToBack(backgroundMaskView)
        pageViewController.view.sendSubviewToBack(backgroundImageView)
        
        pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - kPageControlHeight, self.view.bounds.size.width, kPageControlHeight)
        pageControl.numberOfPages = contents.count;
        pageControl.autoresizingMask = .FlexibleWidth | .FlexibleTopMargin
        self.view.addSubview(pageControl)
    }
    
    // convenience setters for content pages
    
    func setIconSize(size: CGFloat) {
        for contentViewController in contents {
            contentViewController.iconSize = size
        }
    }
    
    func setTitleTextColor(color: UIColor) {
        for contentViewController in contents {
            contentViewController.titleTextColor = color
        }
    }
    
    func setBodyTextColor(color: UIColor) {
        for contentViewController in contents {
            contentViewController.bodyTextColor = color
        }
    }
    
    func setButtonTextColor(color: UIColor) {
        for contentViewController in contents {
            contentViewController.buttonTextColor = color
        }
    }
    
    func setFontName(fontName: String) {
        for contentViewController in contents {
            contentViewController.fontName = fontName
        }
    }
    
    func setTitleFontSize(size: CGFloat) {
        for contentViewController in contents {
            contentViewController.titleFontSize = size
        }
    }
    
    func setBodyFontSize(size: CGFloat) {
        for contentViewController in contents {
            contentViewController.bodyFontSize = size
        }
    }
    
    func setTopPadding(padding: CGFloat) {
        for contentViewController in contents {
            contentViewController.topPadding = padding
        }
    }
    
    func setUnderIconPadding(padding: CGFloat) {
        for contentViewController in contents {
            contentViewController.underIconPadding = padding
        }
    }
    
    func setUnderTitlePadding(padding: CGFloat) {
        for contentViewController in contents {
            contentViewController.underTitlePadding = padding
        }
    }
    
    func setBottomPadding(padding: CGFloat) {
        for contentViewController in contents {
            contentViewController.bottomPadding = padding
        }
    }
    
    // convenience methods
    
    func indexOfViewController(viewController: UIViewController) -> Int {
        var indexOfVC: Int = 0
        for (index, element) in enumerate(contents) {
            if element == viewController {
                indexOfVC = index
                break
            }
        }
        return indexOfVC
    }
    
    // PRAGMA: page view controller data source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentVC = indexOfViewController(viewController)
        return indexOfCurrentVC < contents.count - 1 ? contents[indexOfCurrentVC + 1] : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let indexOfCurrentVC = indexOfViewController(viewController)
        return indexOfCurrentVC > 0 ? contents[indexOfCurrentVC - 1] : nil
    }
    
    
    // PRAGMA: page view controller delegate
    
    func pageViewController(pageViewController: UIPageViewController!, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject]!, transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        
        let newViewController = pageViewController.viewControllers[0] as UIViewController
        pageControl.currentPage = indexOfViewController(newViewController)
    }
}