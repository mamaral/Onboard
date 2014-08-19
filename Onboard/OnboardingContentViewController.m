//
//  OnboardingContentViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingContentViewController.h"

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
    CGFloat labelWidth = viewWidth * 0.9;
    CGFloat padding = 20;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    [imageView setFrame:CGRectMake((viewWidth / 2) - (100 / 2), 4 * padding , 100, 100)];
    [self.view addSubview:imageView];
    
    UILabel *mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(imageView.frame) + padding, labelWidth, 0)];
    mainTextLabel.text = _titleText;
    mainTextLabel.textColor = [UIColor whiteColor];
    mainTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:38];
    mainTextLabel.numberOfLines = 0;
    mainTextLabel.textAlignment = NSTextAlignmentCenter;
    [mainTextLabel sizeToFit];
    mainTextLabel.center = CGPointMake(horizontalCenter, mainTextLabel.center.y);
    [self.view addSubview:mainTextLabel];
    
    UILabel *subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(mainTextLabel.frame) + padding, labelWidth, 0)];
    subTextLabel.text = _body;
    subTextLabel.textColor = [UIColor whiteColor];
    subTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:28];
    subTextLabel.numberOfLines = 0;
    subTextLabel.textAlignment = NSTextAlignmentCenter;
    [subTextLabel sizeToFit];
    subTextLabel.center = CGPointMake(horizontalCenter, subTextLabel.center.y);
    [self.view addSubview:subTextLabel];
    
    // create the action button
    if (_buttonText) {
        UIButton *actionButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetMaxX(self.view.frame) / 2) - (labelWidth / 2), CGRectGetMaxY(self.view.frame) - 100 - padding, labelWidth, 50)];
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
