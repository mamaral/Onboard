//
//  OnboardingContentViewController.swift
//  OnboardSwift
//
//  Created by Mike on 9/11/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

import UIKit

class OnboardingContentViewController: UIViewController {
    let kDefaultOnboardingFont: String = "Helvetica-Light"
    let kDefaultTextColor: UIColor = UIColor.whiteColor()
    let kContentWidthMultiplier: CGFloat = 0.9
    let kDefaultImageViewSize: CGFloat = 100
    let kDefaultTopPadding: CGFloat = 60
    let kDefaultUnderIconPadding: CGFloat = 30
    let kDefaultUnderTitlePadding: CGFloat = 30
    let kDefaultBottomPadding: CGFloat = 0;
    let kDefaultTitleFontSize: CGFloat = 38
    let kDefaultBodyFontSize: CGFloat = 28
    let kDefaultActionButtonHeight: CGFloat = 50
    let kDefaultMainPageControlHeight: CGFloat = 35
    let titleText: String
    let body: String
    let image: UIImage
    let buttonText: String
    let action: dispatch_block_t?
    
    var iconSize: CGFloat
    var fontName: String
    var titleFontSize: CGFloat
    var bodyFontSize: CGFloat
    var topPadding: CGFloat
    var underIconPadding: CGFloat
    var underTitlePadding: CGFloat
    var bottomPadding: CGFloat
    var titleTextColor: UIColor
    var bodyTextColor: UIColor
    var buttonTextColor: UIColor
    
    
    init(title: String?, body: String?, image: UIImage?, buttonText: String?, action: dispatch_block_t?) {
        // setup the optional initializer parameters if they were passed in or not
        self.titleText = title != nil ? title! : String()
        self.body = body != nil ? body! : String()
        self.image = image != nil ? image! : UIImage()
        self.buttonText = buttonText != nil ? buttonText! : String()
        self.action = action != nil ? action : {}
        
        // setup the initial default properties
        self.iconSize = kDefaultImageViewSize;
        self.fontName = kDefaultOnboardingFont;
        self.titleFontSize = kDefaultTitleFontSize;
        self.bodyFontSize = kDefaultBodyFontSize;
        self.topPadding = kDefaultTopPadding;
        self.underIconPadding = kDefaultUnderIconPadding;
        self.underTitlePadding = kDefaultUnderTitlePadding;
        self.bottomPadding = kDefaultBottomPadding;
        self.titleTextColor = kDefaultTextColor;
        self.bodyTextColor = kDefaultTextColor;
        self.buttonTextColor = kDefaultTextColor;
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        generateView()
    }
    
    func generateView() {
        // the background of each content page will be clear to be able to
        // see through to the background image of the master view controller
        self.view.backgroundColor = UIColor.clearColor()
        
        // do some calculation for some values we'll need to reuse, namely the width of the view,
        // the center of the width, and the content width we want to fill up, which is some
        // fraction of the view width we set in the multipler constant
        let viewWidth: CGFloat = CGRectGetWidth(self.view.frame)
        let horizontalCenter: CGFloat = viewWidth / 2
        let contentWidth: CGFloat = viewWidth * kContentWidthMultiplier

        // create the image view with the appropriate image, size, and center in on screen
        var imageView: UIImageView = UIImageView(image: self.image)
        imageView.frame = CGRectMake(horizontalCenter - (self.iconSize / 2), self.topPadding, self.iconSize, self.iconSize)
        self.view.addSubview(imageView)
        
        var titleLabel: UILabel = UILabel(frame: CGRectMake(0, CGRectGetMaxY(imageView.frame) + self.underIconPadding, contentWidth, 0))
        titleLabel.text = self.titleText
        titleLabel.font = UIFont(name: self.fontName, size: self.titleFontSize)
        titleLabel.textColor = self.titleTextColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.sizeToFit()
        titleLabel.center = CGPointMake(horizontalCenter, titleLabel.center.y)
        self.view.addSubview(titleLabel)
        
        var bodyLabel: UILabel = UILabel(frame: CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + self.underTitlePadding, contentWidth, 0))
        bodyLabel.text = self.body
        bodyLabel.font = UIFont(name: self.fontName, size: self.bodyFontSize)
        bodyLabel.textColor = self.titleTextColor
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .Center
        bodyLabel.sizeToFit()
        bodyLabel.center = CGPointMake(horizontalCenter, bodyLabel.center.y)
        self.view.addSubview(bodyLabel)
        
        if (countElements(self.buttonText) != 0) {
            var actionButton: UIButton = UIButton(frame: CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (contentWidth / 2), CGRectGetMaxY(self.view.frame) - kDefaultMainPageControlHeight - kDefaultActionButtonHeight - self.bottomPadding, contentWidth, kDefaultActionButtonHeight))
            actionButton.titleLabel?.font = UIFont .systemFontOfSize(24)
            actionButton.setTitle(self.buttonText, forState: .Normal)
            actionButton.setTitleColor(self.buttonTextColor, forState: .Normal)
            actionButton.addTarget(self, action: "handleButtonPressed", forControlEvents: .TouchUpInside)
            self.view.addSubview(actionButton)
        }
    }
    
    func handleButtonPressed() {
        self.action!()
    }

}
