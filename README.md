Onboard
==================

Onboard provides developers with a quick and easy means to create a beautiful, engaging, and useful onboarding experience.


Usage
=====

Drop the OnboardingViewController and OnboardingContentViewController header and implementation files into your project, import them into your AppDelegate, and you're ready to create an awesome onboarding experience for your users!

Create individual pages by creating an OnboardingContentViewController, providing it a title, body, image, text for an action button, and within the action block

```js
OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Page Title" body:@"Page body goes here." image:[UIImage imageNamed:@"icon"] buttonText:@"Text For Button" action:^{
    // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
}];

```

Then create the OnboardingViewController by providing a background image and an array of OnboardingContentViewControllers you just created. You can then present the view modally and get the onboarding process started!

```js
OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"background"] contents:@[firstPage, secondPage, thirdPage]];

```

With only a few lines of code you have an beautiful, end-to-end onboarding process that will get your users excited to user your awesome applications.


![demo](onboard_demo.gif)


Community
=====

Questions, comments, issues, and pull requests welcomed!!


License
=====

This project is made available under the MIT license. See LICENSE.txt for details.
