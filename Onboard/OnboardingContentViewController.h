//
//  OnboardingContentViewController.h
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnboardingContentViewController : UIViewController {
    NSString *_titleText;
    NSString *_body;
    UIImage *_image;
    NSString *_buttonText;
    dispatch_block_t _actionHandler;
}

- (id)initWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action;

@end
